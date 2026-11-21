# Windows counterpart of update_chad.sh / Makefile "update"
$ErrorActionPreference = 'Stop'

Write-Host '==> Updating Lazy.nvim plugins...' -ForegroundColor Cyan
nvim --headless '+Lazy! update' +qa

Write-Host '==> Updating Mason packages...' -ForegroundColor Cyan
nvim --headless '+MasonUpdate' +qa

Write-Host '==> Updating Treesitter parsers...' -ForegroundColor Cyan
nvim --headless '+TSUpdateSync' +qa

Write-Host '==> Running :checkhealth...' -ForegroundColor Cyan
nvim --headless '+checkhealth' +qa

Write-Host 'Neovim update complete!' -ForegroundColor Green
