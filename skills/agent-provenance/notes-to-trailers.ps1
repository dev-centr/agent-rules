# Read-only exporter for completed commits. Does NOT install a hook or amend commits.
[CmdletBinding()]
param(
    [string]$Commit = 'HEAD',
    [string[]]$OwnedRepository = @()
)
$ErrorActionPreference = 'Stop'
if ($OwnedRepository.Count -eq 0) { return }
$oldEncoding = [Console]::OutputEncoding
try {
    [Console]::OutputEncoding = New-Object Text.UTF8Encoding($false)
    $remotes = @(& git remote)
    if ($LASTEXITCODE -ne 0 -or $remotes.Count -eq 0) { throw 'Repository remotes required.' }
    # Fail closed: forks with a third-party upstream remote are not owned projects.
    foreach ($remote in $remotes) {
        foreach ($mode in @('--fetch', '--push')) {
            $gitArgs = @('remote','get-url','--all')
            if ($mode -eq '--push') { $gitArgs += '--push' }
            $urls = @(& git @gitArgs $remote)
            if ($LASTEXITCODE -ne 0) { throw 'Cannot inspect remote URL.' }
            foreach ($url in $urls) {
                if ($url -notmatch '^(?:https://github\.com/|git@github\.com:)([^/]+/[^/]+?)(?:\.git)?/?$') { return }
                if ($Matches[1] -notin $OwnedRepository) { return }
            }
        }
    }
    $sha = & git rev-parse --verify --end-of-options "$Commit^{commit}"
    if ($LASTEXITCODE -ne 0) { throw 'Invalid commit.' }
    # Test whether the note exists without treating missing data as human work.
    $entries = @(& git notes --ref=ai list)
    if ($LASTEXITCODE -ne 0) { throw 'Cannot list AI notes.' }
    if (-not ($entries | Where-Object { ($_ -split ' ')[-1] -eq $sha })) { return }
    $note = (& git notes --ref=ai show $sha) -join "`n"
    if ($LASTEXITCODE -ne 0) { throw 'Cannot read AI note.' }
    $parts = ([regex]'(?m)^---\r?$').Split($note, 2)
    if ($parts.Count -ne 2) { throw 'Unsupported Git AI note format.' }
    $metadata = $parts[1] | ConvertFrom-Json
    if ($metadata.schema_version -ne 'authorship/3.0.0') { throw 'Unsupported authorship schema.' }
    $records = @{}
    foreach ($name in @('sessions','prompts')) {
        $map = $metadata.$name
        if ($null -ne $map) {
            foreach ($property in $map.PSObject.Properties) { $records[$property.Name] = $property.Value }
        }
    }
    $tools = @(); $models = @()
    foreach ($line in ($parts[0] -split "`n")) {
        if ($line -notmatch '^  (\S+) [0-9,-]+\r?$') { continue }
        $key = ($Matches[1] -split '::')[0]
        if ($key.StartsWith('h_')) { continue }
        if (-not $records.ContainsKey($key)) { throw 'Unresolved AI attestation key.' }
        $agent = $records[$key].agent_id
        $tool = [string]$agent.tool; $model = [string]$agent.model
        if (-not $tool) { $tool = 'unknown' }
        if (-not $model) { $model = 'unknown' }
        if ($tool -match '[\r\n\x00-\x1f]' -or $model -match '[\r\n\x00-\x1f]') { throw 'Invalid agent identity.' }
        $tools += $tool
        $models += "$tool/$model"
    }
    foreach ($tool in ($tools | Sort-Object -Unique)) { "Agent-Harness: $tool" }
    foreach ($model in ($models | Sort-Object -Unique)) { "Agent-Model: $model" }
} finally { [Console]::OutputEncoding = $oldEncoding }
