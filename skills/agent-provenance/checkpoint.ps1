# Dot-source this file. No install or config side effects.
function Invoke-GitAiEdit {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)][string]$Repo,
        [Parameter(Mandatory=$true)][ValidatePattern('^[a-z0-9]+(-[a-z0-9]+)*$')][string]$Harness,
        [Parameter(Mandatory=$true)][string]$Model,
        [Parameter(Mandatory=$true)][string]$ConversationId,
        [Parameter(Mandatory=$true)][object[]]$Messages,
        [Parameter(Mandatory=$true)][string[]]$Paths,
        [Parameter(Mandatory=$true)][scriptblock]$Edit
    )
    if ($Messages.Count -eq 0 -or $Paths.Count -eq 0) { throw 'Real messages and edited paths are required.' }
    foreach ($message in $Messages) {
        if ($message.type -notin @('user','assistant','tool_use')) { throw 'Unsupported transcript message type.' }
    }
    Push-Location -LiteralPath $Repo
    try {
        $top = & git rev-parse --show-toplevel
        if ($LASTEXITCODE -ne 0) { throw 'Not a Git worktree.' }
        $repoPath = (Get-Location).Path
        if (-not (Get-Command git-ai -ErrorAction SilentlyContinue)) {
            Write-Warning 'git-ai unavailable; edit will have no Git AI checkpoint.'
            & $Edit
            return
        }
        $oldOutput = $OutputEncoding
        $oldInput = [Console]::InputEncoding
        $oldConsoleOutput = [Console]::OutputEncoding
        try {
            $OutputEncoding = New-Object Text.UTF8Encoding($false)
            [Console]::InputEncoding = $OutputEncoding
            [Console]::OutputEncoding = $OutputEncoding
            $before = @{ type='human'; repo_working_dir=$repoPath; will_edit_filepaths=@($Paths) }
            $before | ConvertTo-Json -Depth 100 -Compress | & git ai checkpoint agent-v1 --hook-input stdin
            if ($LASTEXITCODE -ne 0) { throw 'Git AI before-edit checkpoint failed; no edit attempted.' }
            try { & $Edit }
            finally {
                $after = @{
                    type='ai_agent'; repo_working_dir=$repoPath
                    agent_name=$Harness; model=$Model; conversation_id=$ConversationId
                    transcript=@{messages=@($Messages)}; edited_filepaths=@($Paths)
                }
                $after | ConvertTo-Json -Depth 100 -Compress | & git ai checkpoint agent-v1 --hook-input stdin
                if ($LASTEXITCODE -ne 0) { throw 'Git AI after-edit checkpoint failed; inspect partial writes.' }
            }
        } finally {
            $OutputEncoding = $oldOutput
            [Console]::InputEncoding = $oldInput
            [Console]::OutputEncoding = $oldConsoleOutput
        }
    } finally { Pop-Location }
}
