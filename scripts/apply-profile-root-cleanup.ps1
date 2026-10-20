#Requires -Version 5.1
<#
.SYNOPSIS
  Move profile-root files per an explicit manifest CSV (no content heuristics).

  Default manifest: AGENT_TEMP_ROOT/manual/profile-root-cleanup/manifest.csv
  Does not touch AGENT_TEMP_ROOT/cursor/ (platform spill).
#>
param(
  [string] $ProfileRoot = $env:USERPROFILE,
  [string] $ManifestPath = '',
  [switch] $WhatIf
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-TempRoot {
  foreach ($root in @($env:CODE_ROOT, $env:code)) {
    if (-not $root) { continue }
    $h = Join-Path $root 'harness.md'
    if (-not (Test-Path -LiteralPath $h)) { continue }
    $text = Get-Content -LiteralPath $h -Raw
    if ($text -match '(?m)^AGENT_TEMP_ROOT\s*=\s*(.+)$') {
      $val = $Matches[1].Trim()
      if ($val -match '^%LOCALAPPDATA%\\(.+)$') { return Join-Path $env:LOCALAPPDATA $Matches[1] }
      return $val
    }
  }
  return Join-Path $env:LOCALAPPDATA 'AgentTemp'
}

$tempRoot = Get-TempRoot
if (-not $ManifestPath) {
  $ManifestPath = Join-Path $tempRoot 'manual\profile-root-cleanup\manifest.csv'
}
if (-not (Test-Path -LiteralPath $ManifestPath)) {
  throw "Manifest not found: $ManifestPath"
}

$manualRoot = Join-Path $tempRoot 'manual'
$moved = 0
$skipped = 0

Import-Csv -LiteralPath $ManifestPath | ForEach-Object {
  $row = $_
  if ($row.action -eq 'keep') {
    $skipped++
    return
  }
  if ($row.action -ne 'move') { return }

  $src = Join-Path $ProfileRoot $row.name
  if (-not (Test-Path -LiteralPath $src)) {
    Write-Warning "Missing: $($row.name)"
    return
  }

  $destDir = Join-Path $manualRoot $row.relativeDest
  $dest = Join-Path $destDir $row.name

  if ($WhatIf) {
    Write-Host "[WhatIf] $($row.name) -> manual\$($row.relativeDest)"
    return
  }
  New-Item -ItemType Directory -Path $destDir -Force | Out-Null
  Move-Item -LiteralPath $src -Destination $dest -Force
  $script:moved++
}

Write-Host "Moved $moved file(s); kept $skipped manifest keep entries. Platform spill (cursor/) untouched."
