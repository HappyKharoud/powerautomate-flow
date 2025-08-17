param(
    [string]$Hostname,
    [string]$Username,
    [string]$Reason,
    [string]$LogFile
)

$logs = Get-Content -Raw "$LogFile" -Encoding UTF8
$logs = $logs -replace "`r?`n", "\n"

$body = @{
    hostname = $Hostname
    username = $Username
    reason   = $Reason
    logs     = $logs
} | ConvertTo-Json -Depth 3

Invoke-RestMethod -Method Post `
    -Uri "https://prod-182.westus.logic.azure.com:443/workflows/ad1af5bfc93c49ff936414191686ff43/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=2P3pqVMErgeEF17ZNmvYa6MPgqamOMWroVPTRuk3bv0" `
    -Body $body `
    -ContentType "application/json"
