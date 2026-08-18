# Create or repair {org}/agent-rules wrapper (template/ submodule + .github pointer).
# Usage:
#   pwsh setup-org-agent-rules-wrapper.ps1 -Org FoodTruckNerdz
#   pwsh setup-org-agent-rules-wrapper.ps1 -Org FoodTruckNerdz -CodeRoot Z:\code\github.com

param(
    [Parameter(Mandatory = $true)]
    [string]$Org,
    [string]$CodeRoot = $(if ($env:code) { $env:code + '\github.com' } elseif ($env:CODE_ROOT) { $env:CODE_ROOT + '\github.com' } else { 'Z:\code\github.com' }),
    [string]$TemplateUrl = 'https://github.com/dev-centr/agent-rules.git'
)

function Set-Utf8NoBomContent {
    param([string]$Path, [string]$Value)
    $utf8 = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($Path, $Value, $utf8)
}

function Write-WrapperReadme($path, $orgName) {
    $text = @'
# agent-rules ({0})

This repository is the org-facing wrapper for shared agent rules.

## Layout

- `template/` - git submodule to `dev-centr/agent-rules` (canonical source)
- `AGENTS.md` - this org's thin overlay and entrypoint

## Contribution flow

- Org-specific guidance: commit in this repo
- Shared portable rules/skills: commit in `template/` and open a PR upstream to `dev-centr/agent-rules`

Do not copy the template tree into this repository.
'@ -f $orgName
    Set-Utf8NoBomContent (Join-Path $path 'README.md') $text
}

function Write-WrapperAgents($path, $orgName) {
    $text = @'
# {0} org overlay

Primary rules source is `template/` (submodule to `dev-centr/agent-rules`).

Use this file only for org-specific overrides that should not apply globally.

When assembling context for this org's repos, resolve:

- `AGENT_RULES_PATH` = `template/` inside this wrapper (or the org clone path)
- Org overlay = this `AGENTS.md`
'@ -f $orgName
    Set-Utf8NoBomContent (Join-Path $path 'AGENTS.md') $text
}

function Write-DotGithubPointer($path, $orgName) {
    $text = @'
# Agent Rules

Org rules live in:

- https://github.com/{0}/agent-rules

That repository wraps the shared template (`dev-centr/agent-rules`) as a `template/` submodule and keeps org-specific overlays in one obvious place.
'@ -f $orgName
    Set-Utf8NoBomContent (Join-Path $path 'AGENT-RULES.md') $text
}

$wrapperPath = Join-Path $CodeRoot "$Org\agent-rules"
$dotGithubPath = Join-Path $CodeRoot "$Org\.github"

gh repo view "$Org/agent-rules" 2>$null
if ($LASTEXITCODE -ne 0) {
    gh repo create "$Org/agent-rules" --public --description "Org wrapper for shared agent-rules template" | Out-Null
}

if (-not (Test-Path $wrapperPath)) {
    gh repo clone "$Org/agent-rules" $wrapperPath | Out-Null
}

Push-Location $wrapperPath
try {
    git fetch --quiet 2>$null
    git checkout main 2>$null
    git pull --ff-only 2>$null

    Write-WrapperReadme $wrapperPath $Org
    Write-WrapperAgents $wrapperPath $Org

    if (-not (Test-Path '.gitmodules')) {
        git submodule add $TemplateUrl template
    }

    git add README.md AGENTS.md .gitmodules template
    if (git diff --cached --quiet) { Write-Host "wrapper unchanged: $Org/agent-rules" }
    else {
        git commit -m "Maintain org agent-rules wrapper with dev-centr template submodule."
        git push
        Write-Host "pushed: $Org/agent-rules"
    }
}
finally { Pop-Location }

if (Test-Path $dotGithubPath) {
    Push-Location $dotGithubPath
    try {
        git fetch --quiet 2>$null
        git checkout main 2>$null
        git pull --ff-only 2>$null

        if (Test-Path 'agent-rules') {
            git rm -rf agent-rules 2>$null
            if (Test-Path '.gitmodules') {
                $lines = Get-Content '.gitmodules' | Where-Object { $_ -notmatch 'submodule "agent-rules"' -and $_ -notmatch '^\s*url = .*agent-rules' -and $_ -notmatch '^\s*path = agent-rules' }
                if ($lines.Count -eq 0) { Remove-Item '.gitmodules' -Force }
                else { Set-Content '.gitmodules' $lines }
            }
        }

        Write-DotGithubPointer $dotGithubPath $Org
        git add -f AGENT-RULES.md .gitmodules 2>$null
        git add -u

        if (git diff --cached --quiet) { Write-Host ".github unchanged: $Org" }
        else {
            git commit -m "Point contributors to org-level agent-rules wrapper repository."
            git push
            Write-Host "updated: $Org/.github"
        }
    }
    finally { Pop-Location }
}
