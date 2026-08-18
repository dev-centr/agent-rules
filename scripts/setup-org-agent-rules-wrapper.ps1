# Create or repair {org}/agent-rules wrapper (pointer README + overlay, no submodule).
# Usage:
#   pwsh setup-org-agent-rules-wrapper.ps1 -Org FoodTruckNerdz
#   pwsh setup-org-agent-rules-wrapper.ps1 -Org FoodTruckNerdz -CodeRoot Z:\code\github.com

param(
    [Parameter(Mandatory = $true)]
    [string]$Org,
    [string]$CodeRoot = $(if ($env:code) { $env:code + '\github.com' } elseif ($env:CODE_ROOT) { $env:CODE_ROOT + '\github.com' } else { 'Z:\code\github.com' }),
    [string]$CanonicalUrl = 'https://github.com/dev-centr/agent-rules'
)

function Set-Utf8NoBomContent {
    param([string]$Path, [string]$Value)
    $utf8 = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($Path, $Value, $utf8)
}

function Write-WrapperReadme($path, $orgName) {
    $text = @'
# agent-rules ({0})

Org overlay for agent rules. Shared portable rules and Cursor skills are **not** copied here — a git submodule would pin a SHA and go stale.

Canonical: https://github.com/dev-centr/agent-rules

Clone or fetch that repo (`$CODE_ROOT/github.com/dev-centr/agent-rules`). Junction skills from there into `~/.cursor/skills/<name>/`.

## Layout

- `AGENTS.md` — this org's overlay (ORG, docs host, forge quirks)

## Contribution flow

- Org-specific guidance: commit in this repo
- Shared rules/skills: PR https://github.com/dev-centr/agent-rules
'@ -f $orgName
    Set-Utf8NoBomContent (Join-Path $path 'README.md') $text
}

function Write-WrapperAgents($path, $orgName) {
    $text = @'
# {0} org overlay

Shared rules and Cursor skills live in **dev-centr/agent-rules**. This repo is the org overlay only — it does not vendor a snapshot.

When assembling context for this org's repos, resolve:

- `AGENT_RULES_PATH` = `$CODE_ROOT/github.com/dev-centr/agent-rules`
- Org overlay = this `AGENTS.md`

Shared changes: PR `dev-centr/agent-rules`. Org-only: commit here.
'@ -f $orgName
    Set-Utf8NoBomContent (Join-Path $path 'AGENTS.md') $text
}

function Write-DotGithubPointer($path, $orgName) {
    $text = @'
# Agent Rules

- Overlay: https://github.com/{0}/agent-rules
- Shared: https://github.com/dev-centr/agent-rules

The wrapper holds org-specific `AGENTS.md` only. Do not submodule the canonical tree — clone/fetch `dev-centr/agent-rules` instead.
'@ -f $orgName
    Set-Utf8NoBomContent (Join-Path $path 'AGENT-RULES.md') $text
}

function Remove-TemplateSubmodule {
    if ((Test-Path '.gitmodules') -or (Test-Path 'template')) {
        git submodule deinit -f -- template 2>$null | Out-Null
        git rm -f template 2>$null | Out-Null
        $mod = Join-Path '.git' 'modules\template'
        if (Test-Path $mod) { Remove-Item -Recurse -Force $mod }
        if ((Test-Path '.gitmodules') -and -not (Get-Content '.gitmodules' -ErrorAction SilentlyContinue | Where-Object { $_.Trim() })) {
            git rm -f .gitmodules 2>$null | Out-Null
            if (Test-Path '.gitmodules') { Remove-Item -Force '.gitmodules' }
        }
        if (Test-Path 'template') { Remove-Item -Recurse -Force 'template' }
    }
}

$wrapperPath = Join-Path $CodeRoot "$Org\agent-rules"
$dotGithubPath = Join-Path $CodeRoot "$Org\.github"

gh repo view "$Org/agent-rules" 2>$null
if ($LASTEXITCODE -ne 0) {
    gh repo create "$Org/agent-rules" --public --description "Org overlay for shared agent-rules (canonical: $CanonicalUrl)" | Out-Null
}

if (-not (Test-Path $wrapperPath)) {
    gh repo clone "$Org/agent-rules" $wrapperPath | Out-Null
}

Push-Location $wrapperPath
try {
    git fetch --quiet 2>$null
    git checkout main 2>$null
    git pull --ff-only 2>$null

    Remove-TemplateSubmodule
    Write-WrapperReadme $wrapperPath $Org
    Write-WrapperAgents $wrapperPath $Org

    git add README.md AGENTS.md
    git add -u
    if (git diff --cached --quiet) { Write-Host "wrapper unchanged: $Org/agent-rules" }
    else {
        git commit -m "Point at canonical agent-rules instead of a pinning submodule."
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
            git commit -m "Point contributors at the org overlay and canonical agent-rules."
            git push
            Write-Host "updated: $Org/.github"
        }
    }
    finally { Pop-Location }
}
