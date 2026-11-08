# Validates routine-ledger schemas/examples and SKILL.md frontmatter.
# Windows PowerShell 5.1 and pwsh 7. Needs Node 18+ and npm on PATH.
# Run from the repo root: powershell -NoProfile -File skills/routine-ledger/test.ps1
$ErrorActionPreference = 'Stop'
$here = $PSScriptRoot
function Assert($condition, $message) { if (-not $condition) { throw $message } }

$skill = [IO.File]::ReadAllText((Join-Path $here 'SKILL.md'), (New-Object Text.UTF8Encoding($false)))
Assert ($skill -match '\A---\n') 'SKILL.md must start with frontmatter and use LF line endings.'
Assert (-not $skill.Contains("`r")) 'SKILL.md contains CR characters.'
$bytes = [IO.File]::ReadAllBytes((Join-Path $here 'SKILL.md'))
Assert (-not ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF)) 'SKILL.md has a BOM.'
$front = ($skill -split "\n---\n", 2)[0]
Assert ($front -match '(?m)^name: routine-ledger$') 'Frontmatter name must be routine-ledger.'
Assert ($front -match '(?m)^description: ') 'Frontmatter description missing.'
Assert ($front.Length -lt 1100) 'Frontmatter description too long.'

$schemaDir = Join-Path (Split-Path (Split-Path $here)) 'schemas/routine-ledger'
foreach ($f in Get-ChildItem -Path $schemaDir -Recurse -File) {
    $b = [IO.File]::ReadAllBytes($f.FullName)
    Assert (-not ($b -contains 13)) "CR found in $($f.Name)."
    Assert (-not ($b.Length -ge 3 -and $b[0] -eq 0xEF -and $b[1] -eq 0xBB)) "BOM found in $($f.Name)."
}

Assert ([bool](Get-Command node -ErrorAction SilentlyContinue)) 'node not on PATH.'
Push-Location $here
try {
    if (-not (Test-Path (Join-Path $here 'node_modules/ajv'))) {
        & npm install --no-audit --no-fund --silent
        Assert ($LASTEXITCODE -eq 0) 'npm install failed.'
    }
    & node validate.mjs
    Assert ($LASTEXITCODE -eq 0) 'Schema validation failed.'
} finally { Pop-Location }
Write-Output 'PASS: SKILL.md frontmatter, UTF-8/LF, all examples valid, negative cases rejected.'
