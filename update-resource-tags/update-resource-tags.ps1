# Script to update Azure Tags. Useful to save time when you need to update multiple resources using the same tag value. 
# Connect to Azure
# Connect-AzAccount

# Define the tag key and the old/new values
$tagKey = "CostCentre"
$oldValue = "C1723"
$newValue = "1723"

# Get all subscriptions in the tenant
$subscriptions = Get-AzSubscription

foreach ($subscription in $subscriptions) {
    Write-Host "`nChecking subscription: $($subscription.Name) ($($subscription.Id))" -ForegroundColor Cyan
    Set-AzContext -SubscriptionId $subscription.Id

    # Get all resources in the current subscription
    $resources = Get-AzResource

    foreach ($resource in $resources) {
        if ($resource.Tags.ContainsKey($tagKey) -and $resource.Tags[$tagKey] -eq $oldValue) {
            # Update the tag value
            $resource.Tags[$tagKey] = $newValue

            # Apply the updated tags
            Set-AzResource -ResourceId $resource.ResourceId -Tag $resource.Tags -Force
            Write-Host "Updated $($resource.Name): $tagKey = $newValue" -ForegroundColor Green
        }
    }
}
