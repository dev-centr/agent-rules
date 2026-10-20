#Requires -Version 5.1
<#
.SYNOPSIS
  Consolidate Cursor agent-tools temp under AGENT_TEMP_ROOT (see general/agent-temp.md).

.DESCRIPTION
  Moves existing agent-tools folders into AGENT_TEMP_ROOT/cursor/... and replaces
  them with directory junctions so Cursor keeps writing into the unified tree.

  Reads AGENT_TEMP_ROOT (or legacy AGENT_SPILL_ROOT) from $env:CODE_ROOT/harness.md;
  default %LOCALAPPDATA%\AgentTemp. Renames legacy AgentSpill folder when found.
#>
param(
  [switch] $WhatIf
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Expand-HarnessPath([string] $Val) {
  $val = $Val.Trim()
  if ($val -match '^%LOCALAPPDATA%\\(.+)$') {
    return Join-Path $env:LOCALAPPDATA $Matches[1]
  }
  if ($val -match '^~\\(.+)$') {
    return Join-Path $env:USERPROFILE $Matches[1]
  }
  return $val
}

function Get-TempRoot {
  $candidates = @($env:CODE_ROOT, $env:code)
  foreach ($root in $candidates) {
    if (-not $root) { continue }
    $harness = Join-Path $root 'harness.md'
    if (-not (Test-Path -LiteralPath $harness)) { continue }
    $text = Get-Content -LiteralPath $harness -Raw
    if ($text -match '(?m)^AGENT_TEMP_ROOT\s*=\s*(.+)$') {
      return Expand-HarnessPath $Matches[1]
    }
    if ($text -match '(?m)^AGENT_SPILL_ROOT\s*=\s*(.+)$') {
      return Expand-HarnessPath $Matches[1]
    }
  }
  return Join-Path $env:LOCALAPPDATA 'AgentTemp'
}

function Migrate-LegacyTempRoot([string] $TempRoot) {
  $legacy = Join-Path $env:LOCALAPPDATA 'AgentSpill'
  if (-not (Test-Path -LiteralPath $legacy)) { return }
  if ($legacy -eq $TempRoot) { return }
  if (Test-Path -LiteralPath $TempRoot) {
    Write-Warning "Both legacy AgentSpill and AGENT_TEMP_ROOT exist; merge manually if needed."
    return
  }
  if ($WhatIf) {
    Write-Host "[WhatIf] rename $legacy -> $TempRoot"
    return
  }
  Rename-Item -LiteralPath $legacy -NewName (Split-Path -Leaf $TempRoot)
  Write-Host "Renamed legacy folder: $legacy -> $TempRoot"
}

function Ensure-Directory([string] $Path) {
  if (-not (Test-Path -LiteralPath $Path)) {
    if ($WhatIf) { Write-Host "[WhatIf] mkdir $Path"; return }
    New-Item -ItemType Directory -Path $Path -Force | Out-Null
  }
}

function Normalize-JunctionTarget($Target) {
  if ($null -eq $Target) { return '' }
  if ($Target -is [Array]) { return ($Target[0]).TrimEnd('\') }
  return $Target.ToString().TrimEnd('\')
}

function Get-HarnessName {
  $candidates = @($env:CODE_ROOT, $env:code)
  foreach ($root in $candidates) {
    if (-not $root) { continue }
    $harness = Join-Path $root 'harness.md'
    if (-not (Test-Path -LiteralPath $harness)) { continue }
    $text = Get-Content -LiteralPath $harness -Raw
    if ($text -match '(?m)^HARNESS_NAME\s*=\s*(.+)$') {
      return $Matches[1].Trim()
    }
  }
  return 'cursor'
}

function Register-SpillLink(
  [string] $RegistryScript,
  [string] $HarnessName,
  [string] $TempRoot,
  [string] $Id,
  [string] $LinkPath,
  [string] $TargetPath,
  [string] $WorkspaceSlug
) {
  if ($WhatIf) { return }
  & $RegistryScript `
    -Id $Id `
    -Harness $HarnessName `
    -PlatformPath $LinkPath `
    -UnifiedPath $TargetPath `
    -WorkspaceSlug $WorkspaceSlug `
    -RecordedBy 'link-script' `
    -TempRoot $TempRoot
}

function Link-AgentTools([string] $LinkPath, [string] $TargetPath) {
  $TargetPath = $TargetPath.TrimEnd('\')
  Ensure-Directory (Split-Path -Parent $TargetPath)
  Ensure-Directory $TargetPath

  if (Test-Path -LiteralPath $LinkPath) {
    $item = Get-Item -LiteralPath $LinkPath -Force
    if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
      $current = Normalize-JunctionTarget $item.Target
      if ($current -ieq $TargetPath -and (Test-Path -LiteralPath $current)) {
        Write-Host "Already linked: $LinkPath"
        return
      }
      if ($WhatIf) {
        Write-Host "[WhatIf] remove stale junction $LinkPath (was $current)"
      } else {
        cmd /c "rmdir `"$LinkPath`"" | Out-Null
      }
    } elseif ($item.PSIsContainer) {
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

$tempRoot = Get-TempRoot
Write-Host "AGENT_TEMP_ROOT = $tempRoot"
Migrate-LegacyTempRoot -TempRoot $tempRoot
Ensure-Directory $tempRoot

$readme = Join-Path $tempRoot 'README.md'
if (-not (Test-Path -LiteralPath $readme) -and -not $WhatIf) {
  @"
# Global agent temp root

Machine-local temp files and Cursor platform tool output. Policy: ``general/agent-temp.md`` in agent-rules.

| Path | Source |
| --- | --- |
| ``cursor/home/agent-tools/`` | Cursor (home / empty-window workspace) |
| ``cursor/projects/<slug>/agent-tools/`` | Cursor (per project slug) |
| ``manual/`` | Agent-authored temp files |
| ``harness/`` | Other harness exports |
| ``spill-registry.json`` | Harness platform spill paths (see agent-rules ``general/agent-temp.md``) |
"@ | Set-Content -LiteralPath $readme -Encoding UTF8
}

Ensure-Directory (Join-Path $tempRoot 'manual')
Ensure-Directory (Join-Path $tempRoot 'harness')

$registryScript = Join-Path $PSScriptRoot 'update-spill-registry.ps1'
$harnessName = Get-HarnessName

$homeLink = Join-Path $env:USERPROFILE 'agent-tools'
$homeTarget = Join-Path $tempRoot 'cursor\home\agent-tools'
Link-AgentTools -LinkPath $homeLink -TargetPath $homeTarget
Register-SpillLink -RegistryScript $registryScript -HarnessName $harnessName -TempRoot $tempRoot `
  -Id 'cursor:home' -LinkPath $homeLink -TargetPath $homeTarget -WorkspaceSlug 'home'

$projectsRoot = Join-Path $env:USERPROFILE '.cursor\projects'
if (Test-Path -LiteralPath $projectsRoot) {
  Get-ChildItem -LiteralPath $projectsRoot -Directory | ForEach-Object {
    $slug = $_.Name
    $link = Join-Path $_.FullName 'agent-tools'
    $target = Join-Path $tempRoot "cursor\projects\$slug\agent-tools"
    Link-AgentTools -LinkPath $link -TargetPath $target
    Register-SpillLink -RegistryScript $registryScript -HarnessName $harnessName -TempRoot $tempRoot `
      -Id "cursor:projects:$slug" -LinkPath $link -TargetPath $target -WorkspaceSlug $slug
  }
}

Write-Host 'Done.'
