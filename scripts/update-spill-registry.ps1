#Requires -Version 5.1
<#
.SYNOPSIS
  Upsert one platform spill path into AGENT_TEMP_ROOT/spill-registry.json

.PARAMETER Id
  Stable key (e.g. cursor:home, cursor:projects:empty-window)

.PARAMETER Harness
  HARNESS_NAME value (e.g. cursor)

.PARAMETER PlatformPath
  Hard-coded path the harness writes (often a junction)

.PARAMETER UnifiedPath
  Canonical path under AGENT_TEMP_ROOT

.PARAMETER RecordedBy
  link-script | agent
#>
param(
  [Parameter(Mandatory)]
  [string] $Id,
  [Parameter(Mandatory)]
  [string] $Harness,
  [Parameter(Mandatory)]
  [string] $PlatformPath,
  [Parameter(Mandatory)]
  [string] $UnifiedPath,
  [ValidateSet('platform-hard-coded', 'agent-manual')]
  [string] $Kind = 'platform-hard-coded',
  [string] $WorkspaceSlug = '',
  [ValidateSet('link-script', 'agent')]
  [string] $RecordedBy = 'agent',
  [string] $LastArtifact = '',
  [string] $TempRoot = ''
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-TempRootFromHarness {
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

$root = if ($TempRoot) { $TempRoot } else { Get-TempRootFromHarness }
if (-not (Test-Path -LiteralPath $root)) {
  New-Item -ItemType Directory -Path $root -Force | Out-Null
}

$registryPath = Join-Path $root 'spill-registry.json'
$now = [DateTimeOffset]::UtcNow.ToString('o')

$doc = [ordered]@{
  schemaVersion = 1
  agentTempRoot = $root
  updated       = $now
  entries       = @()
}

if (Test-Path -LiteralPath $registryPath) {
  try {
    $existing = Get-Content -LiteralPath $registryPath -Raw -Encoding UTF8 | ConvertFrom-Json
    if ($existing.entries) {
      $doc.entries = @($existing.entries)
    }
    if ($existing.schemaVersion) { $doc.schemaVersion = $existing.schemaVersion }
  } catch {
    Write-Warning "Could not parse existing registry; rebuilding entries list."
  }
}

$platformPath = $PlatformPath.TrimEnd('\')
$unifiedPath = $UnifiedPath.TrimEnd('\')

$match = $doc.entries | Where-Object { $_.id -eq $Id } | Select-Object -First 1
if ($match) {
  $match.harness = $Harness
  $match.kind = $Kind
  $match.platformPath = $platformPath
  $match.unifiedPath = $unifiedPath
  $match.workspaceSlug = $WorkspaceSlug
  $match.lastSeen = $now
  if ($LastArtifact) { $match.lastArtifact = $LastArtifact }
  if (-not $match.firstRecorded) { $match.firstRecorded = $now }
  if ($RecordedBy -eq 'link-script' -and -not $match.recordedBy) { $match.recordedBy = 'link-script' }
} else {
  $entry = [ordered]@{
    id            = $Id
    harness       = $Harness
    kind          = $Kind
    platformPath  = $platformPath
    unifiedPath   = $unifiedPath
    workspaceSlug = $WorkspaceSlug
    recordedBy    = $RecordedBy
    firstRecorded = $now
    lastSeen      = $now
  }
  if ($LastArtifact) { $entry.lastArtifact = $LastArtifact }
  $doc.entries = @($doc.entries) + @([pscustomobject]$entry)
}

$doc.updated = $now
($doc | ConvertTo-Json -Depth 6) | Set-Content -LiteralPath $registryPath -Encoding UTF8
