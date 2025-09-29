param(
    [string]$hostname,
    [string]$username,
    [string]$serial,
    [string]$snipeDomain,
    [string]$apiToken
)

$headers = @{
    "Authorization" = $apiToken
    "Accept" = "application/json"
    "ContentType" = "application/json"
}

# Function to assign assets to users
function assignTo() { 
    $assetID = $asset.id
    $postBody = @{
        "checkout_to_type" = "user"
        "assigned_user" = $snipeUserID
        "status_id" = 2
        "note" = "[AD Script] Asset $($asset.name) assigned to $($username). Serial Number: $($serial). Reason: $($username) signed in on an un-anssigned device."

    }
    $response = Invoke-RestMethod -Method Post -Uri "$snipeDomain/api/v1/hardware/$($assetID)/checkout" -Body $postBody -Headers $headers
}

# Function to get User ID from username
function getUserID() {
    try {
        $response = Invoke-RestMethod -Method GET -Uri "$snipeDomain/api/v1/users?username=$username" -Headers $headers
        return $response.rows.id
    }
    catch {
        Write-Error "Failed to retrieve user ID: $($_.Exception.Message)"
        Write-Error "Raw response: $($_.ErrorDetails.Message)"
    }
}

$response = Invoke-RestMethod -Method GET -Uri "$snipeDomain/api/v1/hardware/byserial/$serial" -Headers $headers

if ($response.status) {
    Write-Warning "Asset does not exist"
    exit
}

$asset = $response.rows[0]

if ($asset.assigned_to) {
    exit
} else {
    $snipeUserID = getUserID
    assignTo

}
