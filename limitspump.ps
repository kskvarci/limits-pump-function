# Input bindings are passed in via param block.
param($Timer)

# Get the current universal time in the default string format.
$currentUTCtime = (Get-Date).ToUniversalTime()

<#
.SYNOPSIS
Update Azure PowerShell modules in an Azure Automation account.

.DESCRIPTION
Azure Resource Quotas into a Log Analytics Workspace (Using PowerShell)
Credit to Original Solution: https://blogs.msdn.microsoft.com/tomholl/2017/06/11/get-alerts-as-you-approach-your-azure-resource-quotas/
#>


$omsWorkspaceId = "log analytics workspace ID here"
$omsSharedKey = "log analytics key here"
$Subscriptions = "subscription ID 1", "subscription ID 2", "etc."
$locations = "eastus2", "centralus"


try
{ 
    "Logging in to Azure..."
    Add-AzAccount -identity
}
catch {
    Write-Error -Message $_.Exception
    throw $_.Exception
}

$LogType = "AzureQuota"
 
$json = ''

# for each subscription get the quota data
foreach ($SubscriptionId in $Subscriptions)
{
Write-Host ("Getting quotas for: " + $SubscriptionId)
Set-AzContext -SubscriptionId $SubscriptionId
$azureContext = Get-AzContext
$SubscriptionName = $azureContext.Subscription.Name

# Get VM quotas
foreach ($location in $locations)
{
    Write-Host ("Getting vm quotas for: " + $location)
    $vmQuotas = Get-AzVMUsage -Location $location
    foreach($vmQuota in $vmQuotas)
    {
        $usage = 0
        if ($vmQuota.Limit -gt 0) { $usage = $vmQuota.CurrentValue / $vmQuota.Limit }
        $json += @"
{ "SubscriptionId":"$SubscriptionId", "Subscription":"$SubscriptionName", "Name":"$($vmQuota.Name.LocalizedValue)", "Category":"Compute", "Location":"$location", "CurrentValue":$($vmQuota.CurrentValue), "Limit":$($vmQuota.Limit),"Usage":$usage },
"@
    }
}

# Get Network Quota
foreach ($location in $locations)
{
    Write-Host ("Getting network quotas for: " + $location)
    $networkQuotas = Get-AzNetworkUsage -location $location
    foreach ($networkQuota in $networkQuotas)
    {
        $usage = 0
        if ($networkQuota.limit -gt 0) { $usage = $networkQuota.currentValue / $networkQuota.limit }
         $json += @"
{ "SubscriptionId":"$SubscriptionId", "Subscription":"$SubscriptionName", "Name":"$($networkQuota.name.localizedValue)", "Category":"Network", "Location":"$location", "CurrentValue":$($networkQuota.currentValue), "Limit":$($networkQuota.limit),"Usage":$usage },
"@
    }
 
}

# Get Storage Quota
foreach ($location in $locations)
{
    Write-Host ("Getting storage quotas for: " + $location)
    $storageQuota = Get-AzStorageUsage -Location $location
    $usage = 0
    if ($storageQuota.Limit -gt 0) { $usage = $storageQuota.CurrentValue / $storageQuota.Limit }
    $json += @"
{ "SubscriptionId":"$SubscriptionId", "Subscription":"$SubscriptionName", "Name":"$($storageQuota.LocalizedName)", "Location":"$location", "Category":"Storage", "CurrentValue":$($storageQuota.CurrentValue), "Limit":$($storageQuota.Limit),"Usage":$usage },
"@
 
}
}

# Wrap in an array

$json = "[$json]"
Write-Host("json: " + $json)
# Create the function to create the authorization signature
Function Build-Signature ($omsWorkspaceId, $omsSharedKey, $date, $contentLength, $method, $contentType, $resource)
{
    Write-Host ("Building signature.")
    $xHeaders = "x-ms-date:" + $date
    $stringToHash = $method + "`n" + $contentLength + "`n" + $contentType + "`n" + $xHeaders + "`n" + $resource
 
    $bytesToHash = [Text.Encoding]::UTF8.GetBytes($stringToHash)
    $keyBytes = [Convert]::FromBase64String($omsSharedKey)
 
    $sha256 = New-Object System.Security.Cryptography.HMACSHA256
    $sha256.Key = $keyBytes
    $calculatedHash = $sha256.ComputeHash($bytesToHash)
    $encodedHash = [Convert]::ToBase64String($calculatedHash)
    $authorization = 'SharedKey {0}:{1}' -f $omsWorkspaceId,$encodedHash
    return $authorization
}
 
 
# Create the function to create and post the request
Function Post-OMSData($omsWorkspaceId, $omsSharedKey, $body, $logType)
{
    Write-Host ("Getting ready to post to log analytics.")
    $method = "POST"
    $contentType = "application/json"
    $resource = "/api/logs"
    $rfc1123date = [DateTime]::UtcNow.ToString("r")
    $contentLength = $body.Length
    $signature = Build-Signature `
        -omsWorkspaceId $omsWorkspaceId `
        -omsSharedKey $omsSharedKey `
        -date $rfc1123date `
        -contentLength $contentLength `
        -fileName $fileName `
        -method $method `
        -contentType $contentType `
        -resource $resource
    $uri = "https://" + $omsWorkspaceId + ".ods.opinsights.azure.com" + $resource + "?api-version=2016-04-01"
 
    $headers = @{
        "Authorization" = $signature;
        "Log-Type" = $logType;
        "x-ms-date" = $rfc1123date;
    }
    
    $response = Invoke-WebRequest -Uri $uri -Method $method -ContentType $contentType -Headers $headers -Body $body -UseBasicParsing
    return $response.StatusCode
 
}
 
# Submit the data to the API endpoint
Post-OMSData -omsWorkspaceId $omsWorkspaceId -omsSharedKey $omsSharedKey -body ([System.Text.Encoding]::UTF8.GetBytes($json)) -logType $logType


# The 'IsPastDue' property is 'true' when the current function invocation is later than scheduled.
if ($Timer.IsPastDue) {
    Write-Host "PowerShell timer is running late!"
}

# Write an information log with the current time.
Write-Host "PowerShell timer trigger function ran! TIME: $currentUTCtime"
