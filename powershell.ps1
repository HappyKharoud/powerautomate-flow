param(
    [string]$Hostname,
    [string]$Username,
    [string]$Reason,
    [string]$LogFile
)

$logs = Get-Content -Raw "$LogFile" -Encoding UTF8 -Tail 70
$logs = $logs -replace "`r?`n", "\n"

$body = @{
    hostname = $Hostname
    username = $Username
    reason   = $Reason
    logs = $logs
} | ConvertTo-Json -Depth 3

Invoke-RestMethod -Method Post `
    -Uri "https://prod-128.westus.logic.azure.com:443/workflows/51187f1a876644878b940e83325a1482/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=0Z6TSfnkiRylRS9aFBJFBPoC0FDMyNqfMXkHE0qajwg" `
    -Body $body `
    -ContentType "application/json"
