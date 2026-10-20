#Requires -Version 5.1
<#
.SYNOPSIS
  Classify and archive AgentTemp cursor/home spill files; seed manual/archive.

  See general/agent-temp.md. Run after link-cursor-agent-temp.ps1.
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
  if ($Name -match '^[0-9a-f]{8}-') { return 'platform-spill-unsorted' }
  return 'misc'
}

$tempRoot = Get-TempRoot
$homeTools = Join-Path $tempRoot 'cursor\home\agent-tools'
$manifestDir = Join-Path $tempRoot 'manual\2026-10-20-cleanup'
$archiveRoot = Join-Path $tempRoot 'manual\archive'

if (-not (Test-Path -LiteralPath $homeTools)) {
  Write-Host "No home agent-tools at $homeTools"
  exit 0
}

if (-not $WhatIf) {
  New-Item -ItemType Directory -Path $manifestDir -Force | Out-Null
  New-Item -ItemType Directory -Path $archiveRoot -Force | Out-Null
}

$rows = @()
Get-ChildItem -LiteralPath $homeTools -File | ForEach-Object {
  $f = $_
  $snippet = ''
  try {
    $snippet = (Get-Content -LiteralPath $f.FullName -TotalCount 15 -ErrorAction Stop) -join ' '
    if ($snippet.Length -gt 2000) { $snippet = $snippet.Substring(0, 2000) }
  } catch { $snippet = '' }

  if ($snippet -match '(?i)password\s*:\s*\S') {
    Write-Warning "Sensitive content in $($f.Name) - move to manual/archive/quarantine for your review."
    $topic = 'quarantine-secrets'
  } else {
    $topic = Get-Topic -Name $f.Name -Snippet $snippet
  }

  $month = $f.LastWriteTime.ToString('yyyy-MM')
  $destDir = Join-Path $archiveRoot "$topic\$month"
  $dest = Join-Path $destDir $f.Name

  if ($WhatIf) {
    Write-Host "[WhatIf] $($f.Name) -> $dest ($topic)"
  } else {
    New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    Move-Item -LiteralPath $f.FullName -Destination $dest -Force
  }

  $rows += [pscustomobject]@{
    file           = $f.Name
    topic          = $topic
    month          = $month
    sizeKB         = [math]::Round($f.Length / 1KB, 1)
    lastWrite      = $f.LastWriteTime.ToString('yyyy-MM-dd')
    destination    = $dest
    snippetPreview = if ($snippet.Length -gt 120) { $snippet.Substring(0, 120) + '…' } else { $snippet }
  }
}

$manifestPath = Join-Path $manifestDir 'home-spill-classification.csv'
if (-not $WhatIf) {
  $rows | Export-Csv -LiteralPath $manifestPath -NoTypeInformation -Encoding UTF8
  @"
# Home workspace spill cleanup

Classified files moved from ``cursor/home/agent-tools/`` into ``manual/archive/<topic>/<yyyy-MM>/``.

Manifest: ``manual/2026-10-20-cleanup/home-spill-classification.csv``

Review ``manual/archive/quarantine-secrets/`` if present — delete after rotating any exposed credentials.
"@ | Set-Content -LiteralPath (Join-Path $manifestDir 'README.md') -Encoding UTF8
}

# Mistaken profile folder
$badProfile = Join-Path $env:USERPROFILE '%userprofile%'
if (Test-Path -LiteralPath $badProfile) {
  $childCount = (Get-ChildItem -LiteralPath $badProfile -Recurse -Force -EA SilentlyContinue | Measure-Object).Count
  if ($childCount -le 1) {
    if ($WhatIf) { Write-Host "[WhatIf] remove $badProfile" }
    else {
      Remove-Item -LiteralPath $badProfile -Recurse -Force
      Write-Host "Removed mistaken folder: $badProfile"
    }
  } else {
    Write-Warning "Not removing $badProfile - unexpected content ($childCount items)."
  }
}

$projRoot = Join-Path $tempRoot 'cursor\projects'
$projRows = @()
if (Test-Path -LiteralPath $projRoot) {
  Get-ChildItem -LiteralPath $projRoot -Directory | ForEach-Object {
    $slug = $_.Name
    $tools = Join-Path $_.FullName 'agent-tools'
    if (-not (Test-Path -LiteralPath $tools)) { return }
    Get-ChildItem -LiteralPath $tools -File -EA SilentlyContinue | ForEach-Object {
      $f = $_
      $snippet = try { (Get-Content -LiteralPath $f.FullName -TotalCount 12 -ErrorAction Stop) -join ' ' } catch { '' }
      $topic = Get-Topic -Name $f.Name -Snippet $snippet
      $month = $f.LastWriteTime.ToString('yyyy-MM')
      $destDir = Join-Path $archiveRoot "project-$slug\$topic\$month"
      $dest = Join-Path $destDir $f.Name
      if ($WhatIf) {
        Write-Host "[WhatIf] [$slug] $($f.Name) -> $dest"
      } else {
        New-Item -ItemType Directory -Path $destDir -Force | Out-Null
        Move-Item -LiteralPath $f.FullName -Destination $dest -Force
      }
      $projRows += [pscustomobject]@{
        slug = $slug; file = $f.Name; topic = $topic; month = $month
        sizeKB = [math]::Round($f.Length / 1KB, 1); destination = $dest
      }
    }
  }
}

if (-not $WhatIf -and $projRows.Count -gt 0) {
  $projRows | Export-Csv -LiteralPath (Join-Path $manifestDir 'project-spill-classification.csv') -NoTypeInformation -Encoding UTF8
}

Write-Host "Classified $($rows.Count) home + $($projRows.Count) project files. Manifest: $manifestPath"
