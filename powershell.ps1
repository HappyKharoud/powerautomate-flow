param(
    [string]$FlowURL,
    [string]$Hostname,
    [string]$Username,
    [string]$Reason,
    [string]$Logs
)

$body = @{
    hostname = $Hostname
    username = $Username
    reason   = $Reason
    logs     = $Logs
} | ConvertTo-Json -Depth 3

Invoke-RestMethod -Method Post `
    -Uri $FlowURL `
    -Body $body `
    -ContentType "application/json"
