#Requires -Version 5.1
<#
.SYNOPSIS
  Restore files from manual/archive back into cursor/ platform spill paths.

  Use after an mistaken organize run that moved harness hard-coded spill.
  Reads manifests from manual/2026-10-20-cleanup/*.csv (or -ManifestDir).
#>
param(
  [string] $ManifestDir = '',
  [switch] $WhatIf
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-TempRoot {
  $candidates = @($env:CODE_ROOT, $env:code)
  foreach ($root in $candidates) {
    if (-not $root) { continue }
    $harness = Join-Path $root 'harness.md'
    if (-not (Test-Path -LiteralPath $harness)) { continue }
    $text = Get-Content -LiteralPath $harness -Raw
    if ($text -match '(?m)^AGENT_TEMP_ROOT\s*=\s*(.+)$') {
      $val = $Matches[1].Trim()
      if ($val -match '^%LOCALAPPDATA%\\(.+)$') { return Join-Path $env:LOCALAPPDATA $Matches[1] }
      return $val
    }
  }
  return Join-Path $env:LOCALAPPDATA 'AgentTemp'
}

$tempRoot = Get-TempRoot
if (-not $ManifestDir) {
  $ManifestDir = Join-Path $tempRoot 'manual\2026-10-20-cleanup'
}

$homeCsv = Join-Path $ManifestDir 'home-spill-classification.csv'
$projCsv = Join-Path $ManifestDir 'project-spill-classification.csv'
$restored = 0

if (Test-Path -LiteralPath $homeCsv) {
  Import-Csv -LiteralPath $homeCsv | ForEach-Object {
    $dest = $_.destination
    if (-not (Test-Path -LiteralPath $dest)) { return }
    $target = Join-Path $tempRoot "cursor\home\agent-tools\$($_.file)"
    $dir = Split-Path -Parent $target
    if ($WhatIf) {
      Write-Host "[WhatIf] $dest -> $target"
    } else {
      New-Item -ItemType Directory -Path $dir -Force | Out-Null
      Move-Item -LiteralPath $dest -Destination $target -Force
      $script:restored++
    }
  }
}

if (Test-Path -LiteralPath $projCsv) {
  Import-Csv -LiteralPath $projCsv | ForEach-Object {
    $dest = $_.destination
    if (-not (Test-Path -LiteralPath $dest)) { return }
    $target = Join-Path $tempRoot "cursor\projects\$($_.slug)\agent-tools\$($_.file)"
    $dir = Split-Path -Parent $target
    if ($WhatIf) {
      Write-Host "[WhatIf] [$($_.slug)] $dest -> $target"
    } else {
      New-Item -ItemType Directory -Path $dir -Force | Out-Null
      Move-Item -LiteralPath $dest -Destination $target -Force
      $script:restored++
    }
  }
}

Write-Host "Restored $restored file(s) into cursor/ platform spill paths."
