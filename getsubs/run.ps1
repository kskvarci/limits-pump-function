# Input bindings are passed in via param block.
param($Timer)

# Get the current universal time in the default string format
$currentUTCtime = (Get-Date).ToUniversalTime()

<#
.SYNOPSIS
Queue writer

.DESCRIPTION
Reads subscriptions visible to MSI that the function is running under. Writes a message to a storage queue for each subscription. 
Messages are picked up by a downstream function that checks subscription limits and writes to a log analytics workspace.
#>

# Log into Azure with function app MSI
try
{ 
    Write-Host "Logging in to Azure w/ MSI..."
    Add-AzAccount -identity
}
catch {
    Write-Error -Message $_.Exception
    throw $_.Exception
}

# Fetch all subscriptions
$subscriptions = Get-AzSubscription

# For each subscription, send a message to the storage queue
foreach ($subscription in $subscriptions){
    Push-OutputBinding -name outputqueue -value $subscription.Id
}

# The 'IsPastDue' porperty is 'true' when the current function invocation is later than scheduled.
if ($Timer.IsPastDue) {
    Write-Host "PowerShell timer is running late!"
}

# Write an information log with the current time.
Write-Host "PowerShell timer trigger function ran! TIME: $currentUTCtime"
