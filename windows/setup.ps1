# Windows Setup Script using winget
# Run as Administrator in PowerShell
# Usage: .\setup.ps1

$ErrorActionPreference = "Stop"

Write-Host "Windows Setup Script" -ForegroundColor Cyan
Write-Host "====================" -ForegroundColor Cyan

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "Warning: Some packages may require Administrator privileges." -ForegroundColor Yellow
}

# Check if winget is available
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "Error: winget is not installed." -ForegroundColor Red
    Write-Host "Please install App Installer from the Microsoft Store." -ForegroundColor Yellow
    exit 1
}

# Get script directory
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$packagesFile = Join-Path $scriptDir "packages.json"

if (-not (Test-Path $packagesFile)) {
    Write-Host "Error: packages.json not found." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Installing packages from packages.json..." -ForegroundColor Green
Write-Host ""

# Import packages
winget import -i $packagesFile --accept-package-agreements --accept-source-agreements

Write-Host ""
Write-Host "Setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Install WSL2: wsl --install" -ForegroundColor White
Write-Host "  2. Set up Nix in WSL2" -ForegroundColor White
Write-Host "  3. Clone dotfiles and run home-manager" -ForegroundColor White
