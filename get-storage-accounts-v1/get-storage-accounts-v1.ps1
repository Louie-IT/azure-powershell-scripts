<#
.SYNOPSIS
Finds all legacy Azure general-purpose v1 storage accounts in all subscriptions
of a given tenant and exports them to a CSV file.

.REQUIREMENTS
- Az PowerShell module
    Install-Module Az -Scope CurrentUser
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$TenantId,
    # Provide the full path to output a CSV file. E.g.: C:\temp\storage-v1-report.csv
    [Parameter(Mandatory = $true)]
    [string]$OutputCsvPath
)

# Connect to Azure
Write-Host "Connecting to Azure tenant $TenantId..."
Connect-AzAccount -Tenant $TenantId -ErrorAction Stop

# Get all subscriptions in the tenant
$subscriptions = Get-AzSubscription
Write-Host "Found $($subscriptions.Count) subscriptions in tenant."

$result = @()

foreach ($sub in $subscriptions) {
    Write-Host "Processing subscription: $($sub.Name) ($($sub.Id))"

    # Set context to the subscription
    Set-AzContext -SubscriptionId $sub.Id | Out-Null

    # Get all storage accounts in this subscription
    $storageAccounts = Get-AzStorageAccount

    # Filter for general-purpose v1 accounts (Kind = 'Storage')
    $gpv1Accounts = $storageAccounts | Where-Object { $_.Kind -eq "Storage" }

    foreach ($sa in $gpv1Accounts) {
        $result += [PSCustomObject]@{
            TenantId          = $TenantId
            SubscriptionId    = $sub.Id
            SubscriptionName  = $sub.Name
            ResourceGroupName = $sa.ResourceGroupName
            StorageAccount    = $sa.StorageAccountName
            Location          = $sa.Location
            Kind              = $sa.Kind
            SkuName           = $sa.Sku.Name
        }
    }
}

if ($result.Count -eq 0) {
    Write-Host "No general-purpose v1 storage accounts found in this tenant."
} else {
    Write-Host "Found $($result.Count) general-purpose v1 storage accounts. Exporting to CSV..."
    $result | Sort-Object SubscriptionName, ResourceGroupName, StorageAccount |
        Export-Csv -Path $OutputCsvPath -NoTypeInformation -Encoding UTF8

    Write-Host "Export complete: $OutputCsvPath"
}
