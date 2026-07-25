# ChipSutra-VLSI-LLM — ensure Ollama exists, build model tag(s)
param(
    [switch]$InstallDependencies,
    [ValidateSet('1.5b', '3b', '7b', 'all')]
    [string]$Tag = '3b'
)

$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $Root

function Test-Cmd($name) {
    return [bool](Get-Command $name -ErrorAction SilentlyContinue)
}

function Ensure-Ollama {
    if (Test-Cmd ollama) { return $true }
    if (-not $InstallDependencies) {
        Write-Host 'Ollama not found. Re-run with -InstallDependencies:'
        Write-Host '  .\scripts\setup-windows.ps1 -InstallDependencies'
        Write-Host 'Or: https://ollama.com/download'
        return $false
    }
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Host 'Install Ollama from https://ollama.com/download'
        return $false
    }
    Write-Host 'Installing Ollama via winget...'
    winget install -e --id Ollama.Ollama --accept-package-agreements --accept-source-agreements
    Write-Host 'Ollama installed. Open a NEW PowerShell window, then re-run this script.'
    return $false
}

if (-not (Ensure-Ollama)) { exit 0 }

function Build-Tag($t, $base, $file) {
    Write-Host "pull $base ..."
    ollama pull $base
    Write-Host "create chipsutra-vlsi:$t ..."
    ollama create "chipsutra-vlsi:$t" -f $file
}

$map = @{
    '1.5b' = @('qwen2.5-coder:1.5b', 'modelfiles\Modelfile.1.5b')
    '3b'   = @('qwen2.5-coder:3b',   'modelfiles\Modelfile.3b')
    '7b'   = @('qwen2.5-coder:7b',   'modelfiles\Modelfile.7b')
}

if ($Tag -eq 'all') {
    foreach ($k in @('1.5b', '3b', '7b')) {
        $m = $map[$k]
        Build-Tag $k $m[0] $m[1]
    }
} else {
    $m = $map[$Tag]
    Build-Tag $Tag $m[0] $m[1]
}

Write-Host 'Done. Test: ollama run chipsutra-vlsi:3b "Write one SVA for reset"'
