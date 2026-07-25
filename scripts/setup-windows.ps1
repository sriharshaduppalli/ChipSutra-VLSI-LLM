# ChipSutra-VLSI-LLM - ensure Ollama exists, build model tag(s)
param(
    [switch]$InstallDependencies,
    [ValidateSet('1.5b', '3b', '7b', 'all')]
    [string]$Tag = '3b'
)

$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $Root

function Refresh-SessionPath {
    $machine = [System.Environment]::GetEnvironmentVariable('Path', 'Machine')
    $user = [System.Environment]::GetEnvironmentVariable('Path', 'User')
    $env:Path = "$machine;$user"
    $ollamaDir = Join-Path $env:LOCALAPPDATA 'Programs\Ollama'
    if (Test-Path $ollamaDir) {
        $env:Path = "$env:Path;$ollamaDir"
    }
}

function Get-OllamaExe {
    Refresh-SessionPath
    $cmd = Get-Command ollama -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }
    $local = Join-Path $env:LOCALAPPDATA 'Programs\Ollama\ollama.exe'
    if (Test-Path $local) { return $local }
    return $null
}

function Invoke-Ollama {
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$Args)
    $exe = Get-OllamaExe
    if (-not $exe) { throw 'ollama not found on PATH. Open a NEW PowerShell window or log out/in after install.' }
    & $exe @Args
    if ($LASTEXITCODE -ne 0) { throw "ollama failed: $Args" }
}

function Ensure-Ollama {
    if (Get-OllamaExe) { return $true }
    if (-not $InstallDependencies) {
        Write-Host 'Ollama not found in this terminal.'
        Write-Host 'Fix: close PowerShell, open a NEW window, then run:'
        Write-Host "  cd $Root"
        Write-Host "  .\setup.ps1 -Tag $Tag"
        Write-Host 'Or: .\setup.ps1 -InstallDependencies -Tag 3b'
        return $false
    }
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Host 'Install Ollama from https://ollama.com/download'
        return $false
    }
    Write-Host 'Installing Ollama via winget...'
    & winget install -e --id Ollama.Ollama --accept-package-agreements --accept-source-agreements
    Refresh-SessionPath
    if (Get-OllamaExe) {
        Write-Host 'Ollama is available in this session.'
        return $true
    }
    Write-Host ''
    Write-Host 'Ollama installed. Start the Ollama app from the Start menu, then open a NEW PowerShell and run:'
    Write-Host "  cd $Root"
    Write-Host "  .\setup.ps1 -Tag $Tag"
    return $false
}

if (-not (Ensure-Ollama)) { return }

function Build-Tag($t, $base, $file) {
    Write-Host "pull $base ..."
    Invoke-Ollama pull $base
    Write-Host "create chipsutra-vlsi:$t ..."
    Invoke-Ollama create "chipsutra-vlsi:$t" -f $file
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
