# Get all subscriptions in the tenant
$Subscriptions = Get-AzSubscription

$Results = @()

foreach ($Sub in $Subscriptions) {
    # Switch to the subscription
    Set-AzContext -SubscriptionId $Sub.Id | Out-Null

    # Get Function Apps in this subscription
    $FunctionApps = Get-AzFunctionApp

    foreach ($App in $FunctionApps) {
        if ($App.Runtime -eq 'dotnet') {
            $Results += [PSCustomObject]@{
                FunctionApp  = $App.Name
                Runtime      = $App.Runtime
                Subscription = $Sub.Name
                SubscriptionId = $Sub.Id
                ResourceGroup = $App.ResourceGroupName
            }
        }
    }
}

# Export to CSV
$CsvPath = ".\DotNetFunctionApps.csv"
$Results | Export-Csv -Path $CsvPath -NoTypeInformation

Write-Host "CSV exported to $CsvPath"
