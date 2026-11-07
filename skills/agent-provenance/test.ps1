# Mocks only; no installation, Git config changes, real commits or notes.
$ErrorActionPreference = 'Stop'
$here = $PSScriptRoot
. (Join-Path $here 'checkpoint.ps1')
$global:requests = @(); $global:order = @()
$global:failBefore = $false; $global:fixture = ''; $global:upstream = $false
function git-ai { }
function git {
    $global:LASTEXITCODE = 0
    if ($args[0] -eq 'rev-parse') {
        if ($args[1] -eq '--show-toplevel') { return (Get-Location).Path }
        return ('a' * 40)
    }
    if ($args[0] -eq 'ai') {
        $json = ($input | Out-String) | ConvertFrom-Json
        $global:requests += $json; $global:order += $json.type
        if ($global:failBefore -and $json.type -eq 'human') { $global:LASTEXITCODE = 1 }
        return
    }
    if ($args[0] -eq 'remote') {
        if ($args.Count -eq 1) { if ($global:upstream) { return @('origin','upstream') }; return 'origin' }
        if ($args[-1] -eq 'upstream') { return 'git@github.com:dlang/dub.git' }
        return 'https://github.com/dev-centr/agent-rules.git'
    }
    if ($args[0] -eq 'notes') {
        if ($args[2] -eq 'list') { return (('b' * 40) + ' ' + ('a' * 40)) }
        return $global:fixture
    }
    throw "Unexpected Git invocation: $args"
}
function Assert($condition, $message) { if (-not $condition) { throw $message } }
$messages = @(@{type='user';text="Unicode: $([char]0x03bb)"})
$beforeEncoding = $OutputEncoding
Invoke-GitAiEdit -Repo $here -Harness 'future-harness' -Model 'unknown' `
    -ConversationId 'stable-session' -Messages $messages -Paths @('a file.txt') -Edit { $global:order += 'edit' }
Assert (($global:order -join ',') -eq 'human,edit,ai_agent') 'Wrong checkpoint order.'
Assert ($global:requests[1].conversation_id -eq 'stable-session') 'Session changed.'
Assert ($global:requests[1].transcript.messages[0].text -eq $messages[0].text) 'Unicode changed.'
Assert ($global:requests[1].edited_filepaths[0] -eq 'a file.txt') 'Path array changed.'
Assert ($OutputEncoding -eq $beforeEncoding) 'Encoding not restored.'
$global:order = @(); $caught = $false
try {
    Invoke-GitAiEdit -Repo $here -Harness 'future-harness' -Model 'unknown' `
        -ConversationId 'stable-session' -Messages $messages -Paths @('a.txt') -Edit { throw 'partial edit failed' }
} catch { $caught = $true }
Assert $caught 'Edit error swallowed.'
Assert (($global:order -join ',') -eq 'human,ai_agent') 'Partial edit not checkpointed.'
$global:failBefore = $true; $caught = $false; $global:order = @()
try {
    Invoke-GitAiEdit -Repo $here -Harness 'future-harness' -Model 'unknown' `
        -ConversationId 'stable-session' -Messages $messages -Paths @('a.txt') -Edit { throw 'must not run' }
} catch { $caught = $true }
Assert ($caught -and ($global:order -join ',') -eq 'human') 'Failed checkpoint allowed edit.'
$global:fixture = "src/example.txt`n  s_one::t_one 1-2`n  legacy 3`n  h_person 4`n---`n" + '{"schema_version":"authorship/3.0.0","sessions":{"s_one":{"agent_id":{"tool":"future-harness","id":"s1","model":"unknown"}},"s_unused":{"agent_id":{"tool":"unused","id":"s2","model":"unused"}}},"prompts":{"legacy":{"agent_id":{"tool":"cursor","id":"s3","model":"exact-model"},"total_additions":1,"total_deletions":0,"accepted_lines":1,"overriden_lines":0}},"humans":{"h_person":{"author":"Human"}}}'
$exporter = Join-Path $here 'notes-to-trailers.ps1'
$output = @(& $exporter -OwnedRepository 'dev-centr/agent-rules')
Assert ($output.Count -eq 4) 'Wrong number of trailers.'
Assert ($output -contains 'Agent-Harness: cursor') 'Legacy record not handled.'
Assert ($output -contains 'Agent-Model: future-harness/unknown') 'Session record not handled.'
Assert (-not ($output -match 'unused')) 'Unattested session leaked into trailers.'
Assert (@(& $exporter).Count -eq 0) 'Default exporter not disabled.'
$global:upstream = $true
Assert (@(& $exporter -OwnedRepository 'dev-centr/agent-rules').Count -eq 0) 'Upstream remote not excluded.'
Write-Output 'PASS: checkpoint order, identity, Unicode, partial failures, encoding restoration, modern/legacy notes, no stale sessions, opt-in and upstream gates.'
