#Requires -Version 5.1
<#
.SYNOPSIS
  Classify and tidy agent-chosen temp under manual/ only.

  Does NOT move harness hard-coded spill (AGENT_TEMP_ROOT/cursor/**). See general/agent-temp.md.
#>
param(
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

function Get-Topic([string] $Name, [string] $Snippet) {
  $s = ($Name + ' ' + $Snippet).ToLowerInvariant()
  $rules = @(
    @{ Topic = 'site-nav-tree'; Pattern = 'site-nav-tree|build-site-navigation|site_nav_tree' }
    @{ Topic = 'valentus-theme'; Pattern = 'valentus-theme|site-doc-layout|adt-breadcrumb' }
    @{ Topic = 'antora-facto'; Pattern = 'facto-stack|page-context|antora-facto|orphan-finder' }
    @{ Topic = 'dev-centr-docs'; Pattern = 'dev-centr\\docs|docs\.devcentr' }
    @{ Topic = 'deps-audit'; Pattern = 'dependabot|"repo","created","issue"|dep-audit|deprecated' }
    @{ Topic = 'hive-layout'; Pattern = '\\.forks|dir amdphreak|github\.com\\amdphreak' }
    @{ Topic = 'career-journey'; Pattern = 'career-journey|better-auth|drizzle-orm' }
    @{ Topic = 'instalay-oauth'; Pattern = 'instalay|oauth 2\.0 authorization' }
    @{ Topic = 'flutter-instalay'; Pattern = 'flutter|pub\.dev|instalay' }
    @{ Topic = 'asciidocfx'; Pattern = 'asciidocfx|AsciidocFX' }
    @{ Topic = 'transcripts'; Pattern = 'jsonl|transcript|NO_TRANSCRIPT_HIT' }
    @{ Topic = 'agent-rules'; Pattern = 'agent-rules|harness\.md|skills-set' }
  )
  foreach ($r in $rules) {
    if ($s -match $r.Pattern) { return $r.Topic }
  }
  return 'misc'
}

$tempRoot = Get-TempRoot
$manualRoot = Join-Path $tempRoot 'manual'
$stamp = (Get-Date).ToString('yyyy-MM-dd')
$manifestDir = Join-Path $manualRoot "$stamp-cleanup"
$archiveRoot = Join-Path $manualRoot 'archive'

if (-not (Test-Path -LiteralPath $manualRoot)) {
  Write-Host "No manual/ tree at $manualRoot"
  exit 0
}

if (-not $WhatIf) {
  New-Item -ItemType Directory -Path $manifestDir -Force | Out-Null
  New-Item -ItemType Directory -Path $archiveRoot -Force | Out-Null
}

# Only agent-chosen temp: loose files under manual/<date>/ (not archive, not *-cleanup manifests)
$rows = @()
Get-ChildItem -LiteralPath $manualRoot -Directory | Where-Object {
  $_.Name -ne 'archive' -and $_.Name -notmatch '-cleanup$'
} | ForEach-Object {
  Get-ChildItem -LiteralPath $_.FullName -File -ErrorAction SilentlyContinue | ForEach-Object {
    $f = $_
    $snippet = try { (Get-Content -LiteralPath $f.FullName -TotalCount 15 -ErrorAction Stop) -join ' ' } catch { '' }
    if ($snippet -match '(?i)password\s*:\s*\S') {
      $topic = 'quarantine-secrets'
    } else {
      $topic = Get-Topic -Name $f.Name -Snippet $snippet
    }
    $month = $f.LastWriteTime.ToString('yyyy-MM')
    $destDir = Join-Path $archiveRoot "$topic\$month"
    $dest = Join-Path $destDir $f.Name
    if ($WhatIf) {
      Write-Host "[WhatIf] $($f.FullName) -> $dest ($topic)"
    } else {
      New-Item -ItemType Directory -Path $destDir -Force | Out-Null
      Move-Item -LiteralPath $f.FullName -Destination $dest -Force
    }
    $rows += [pscustomobject]@{
      file = $f.Name; sourceDir = $f.DirectoryName; topic = $topic; month = $month
      sizeKB = [math]::Round($f.Length / 1KB, 1); destination = $dest
    }
  }
}

$manifestPath = Join-Path $manifestDir 'manual-classification.csv'
if (-not $WhatIf) {
  if ($rows.Count -gt 0) {
    $rows | Export-Csv -LiteralPath $manifestPath -NoTypeInformation -Encoding UTF8
  }
  @"
# Agent-chosen temp cleanup ($stamp)

Organized loose files from ``manual/<date>/`` into ``manual/archive/<topic>/<yyyy-MM>/``.

**Does not touch** ``cursor/`` (harness hard-coded platform spill).

Manifest: ``manual/$stamp-cleanup/manual-classification.csv``
"@ | Set-Content -LiteralPath (Join-Path $manifestDir 'README.md') -Encoding UTF8
}

$badProfile = Join-Path $env:USERPROFILE '%userprofile%'
if (Test-Path -LiteralPath $badProfile) {
  $childCount = (Get-ChildItem -LiteralPath $badProfile -Recurse -Force -EA SilentlyContinue | Measure-Object).Count
  if ($childCount -le 1) {
    if ($WhatIf) { Write-Host "[WhatIf] remove $badProfile" }
    else {
      Remove-Item -LiteralPath $badProfile -Recurse -Force
      Write-Host "Removed mistaken folder: $badProfile"
    }
  }
}

Write-Host "Organized $($rows.Count) manual temp file(s). Platform spill under cursor/ was left unchanged."
