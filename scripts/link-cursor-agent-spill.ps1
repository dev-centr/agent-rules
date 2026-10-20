#Requires -Version 5.1
<#
.SYNOPSIS
  Consolidate Cursor agent-tools spill under AGENT_SPILL_ROOT (see general/agent-spill.md).

.DESCRIPTION
  Moves existing agent-tools folders into AGENT_SPILL_ROOT/cursor/... and replaces
  them with directory junctions so Cursor keeps writing into the unified tree.

  Reads AGENT_SPILL_ROOT from $env:CODE_ROOT/harness.md when set; else
  %LOCALAPPDATA%\AgentSpill.
#>
param(
  [switch] $WhatIf
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-SpillRoot {
  $candidates = @($env:CODE_ROOT, $env:code)
  foreach ($root in $candidates) {
    if (-not $root) { continue }
    $harness = Join-Path $root 'harness.md'
    if (-not (Test-Path -LiteralPath $harness)) { continue }
    $text = Get-Content -LiteralPath $harness -Raw
    if ($text -match '(?m)^AGENT_SPILL_ROOT\s*=\s*(.+)$') {
      $val = $Matches[1].Trim()
      if ($val -match '^%LOCALAPPDATA%\\(.+)$') {
        return Join-Path $env:LOCALAPPDATA $Matches[1]
      }
      if ($val -match '^~\(.+)$') {
        return Join-Path $env:USERPROFILE ($val -replace '^~\\', '')
      }
      return $val
    }
  }
  return Join-Path $env:LOCALAPPDATA 'AgentSpill'
}

function Ensure-Directory([string] $Path) {
  if (-not (Test-Path -LiteralPath $Path)) {
    if ($WhatIf) { Write-Host "[WhatIf] mkdir $Path"; return }
    New-Item -ItemType Directory -Path $Path -Force | Out-Null
  }
}

function Link-AgentTools([string] $LinkPath, [string] $TargetPath) {
  Ensure-Directory (Split-Path -Parent $TargetPath)
  Ensure-Directory $TargetPath

  if (Test-Path -LiteralPath $LinkPath) {
    $item = Get-Item -LiteralPath $LinkPath -Force
    if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
      Write-Host "Already junction: $LinkPath"
      return
    }
    if ($item.PSIsContainer) {
      $existing = Get-ChildItem -LiteralPath $LinkPath -Force -ErrorAction SilentlyContinue
      foreach ($child in $existing) {
        $dest = Join-Path $TargetPath $child.Name
        if (Test-Path -LiteralPath $dest) {
          Write-Warning "Skip move (exists): $($child.FullName) -> $dest"
          continue
        }
        if ($WhatIf) {
          Write-Host "[WhatIf] move $($child.FullName) -> $dest"
        } else {
          Move-Item -LiteralPath $child.FullName -Destination $dest
        }
      }
      if (-not $WhatIf) {
        Remove-Item -LiteralPath $LinkPath -Recurse -Force
      }
    } else {
      throw "agent-tools path is a file, not a directory: $LinkPath"
    }
  }

  if ($WhatIf) {
    Write-Host "[WhatIf] junction $LinkPath -> $TargetPath"
    return
  }
  New-Item -ItemType Junction -Path $LinkPath -Target $TargetPath | Out-Null
  Write-Host "Linked: $LinkPath -> $TargetPath"
}

$spillRoot = Get-SpillRoot
Write-Host "AGENT_SPILL_ROOT = $spillRoot"
Ensure-Directory $spillRoot

$readme = Join-Path $spillRoot 'README.md'
if (-not (Test-Path -LiteralPath $readme) -and -not $WhatIf) {
  @"
# Agent spill root

Machine-local scratch and Cursor platform tool output. Policy: ``general/agent-spill.md`` in agent-rules.

| Path | Source |
| --- | --- |
| ``cursor/home/agent-tools/`` | Cursor (home / empty-window workspace) |
| ``cursor/projects/<slug>/agent-tools/`` | Cursor (per project slug) |
| ``manual/`` | Agent-authored temp files |
| ``harness/`` | Other harness exports |
"@ | Set-Content -LiteralPath $readme -Encoding UTF8
}

Ensure-Directory (Join-Path $spillRoot 'manual')
Ensure-Directory (Join-Path $spillRoot 'harness')

$homeLink = Join-Path $env:USERPROFILE 'agent-tools'
$homeTarget = Join-Path $spillRoot 'cursor\home\agent-tools'
Link-AgentTools -LinkPath $homeLink -TargetPath $homeTarget

$projectsRoot = Join-Path $env:USERPROFILE '.cursor\projects'
if (Test-Path -LiteralPath $projectsRoot) {
  Get-ChildItem -LiteralPath $projectsRoot -Directory | ForEach-Object {
    $slug = $_.Name
    $link = Join-Path $_.FullName 'agent-tools'
    if (-not (Test-Path -LiteralPath $link)) {
      # Pre-create junction so the first platform spill lands in the unified tree
      $target = Join-Path $spillRoot "cursor\projects\$slug\agent-tools"
      if ($WhatIf) {
        Write-Host "[WhatIf] pre-link $link -> $target"
      } else {
        Link-AgentTools -LinkPath $link -TargetPath $target
      }
      return
    }
    $target = Join-Path $spillRoot "cursor\projects\$slug\agent-tools"
    Link-AgentTools -LinkPath $link -TargetPath $target
  }
}

Write-Host 'Done.'
