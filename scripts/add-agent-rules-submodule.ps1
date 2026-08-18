# Deprecated: use setup-org-agent-rules-wrapper.ps1
# Old pattern put agent-rules inside .github; the house pattern is {org}/agent-rules (pointer + overlay, no submodule).

Write-Host "Use setup-org-agent-rules-wrapper.ps1 instead."
Write-Host "  pwsh $PSScriptRoot/setup-org-agent-rules-wrapper.ps1 -Org <org>"
exit 1
