param(
    [string]$Model = 'chipsutra-vlsi:3b',
    [string]$Prompt = 'Write one SVA property for async reset deassertion sync to clk. Output SV only.'
)
$ErrorActionPreference = 'Stop'

if (-not (Get-Command ollama -ErrorAction SilentlyContinue)) {
    throw 'Ollama not found. Install it from https://ollama.com/download'
}
ollama show $Model *> $null
if ($LASTEXITCODE -ne 0) {
    throw "Model $Model is missing. Run .\scripts\create-all.ps1"
}

$body = @{
    model = $Model
    stream = $false
    messages = @(@{ role = 'user'; content = $Prompt })
} | ConvertTo-Json -Depth 5

$result = Invoke-RestMethod -Method Post -Uri 'http://localhost:11434/api/chat' -ContentType 'application/json' -Body $body
$text = [string]$result.message.content
Write-Host $text.Substring(0, [Math]::Min(500, $text.Length))
Write-Host "`n[verify] OK - model $Model responded"
