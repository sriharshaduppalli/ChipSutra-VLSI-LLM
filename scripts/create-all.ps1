# ChipSutra-VLSI-LLM — build all Ollama tags locally (no API keys)
$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $Root

function New-ChipSutraModel {
    param([string]$Tag, [string]$Base, [string]$Modelfile)
    Write-Host "[chipsutra-vlsi] pulling $Base..."
    ollama pull $Base
    Write-Host "[chipsutra-vlsi] creating chipsutra-vlsi:$Tag..."
    ollama create "chipsutra-vlsi:$Tag" -f $Modelfile
}

New-ChipSutraModel "1.5b" "qwen2.5-coder:1.5b" "modelfiles\Modelfile.1.5b"
New-ChipSutraModel "3b"   "qwen2.5-coder:3b"   "modelfiles\Modelfile.3b"
New-ChipSutraModel "7b"   "qwen2.5-coder:7b"   "modelfiles\Modelfile.7b"

Write-Host "[chipsutra-vlsi] done. Try: ollama run chipsutra-vlsi:3b"
