# List all Virtual Machines that have backup enabled.
# Login to Azure
# Connect-AzAccount

# Initialize array to hold VM backup info
$protectedVMs = @()

# Get all subscriptions
$subscriptions = Get-AzSubscription

foreach ($sub in $subscriptions) {
    # Set context to current subscription
    Set-AzContext -SubscriptionId $sub.Id

    # Get all Recovery Services Vaults in this subscription
    $vaults = Get-AzRecoveryServicesVault

    foreach ($vault in $vaults) {
        # Set context to current vault
        Set-AzRecoveryServicesVaultContext -Vault $vault

        # Get all containers of type AzureVM
        $containers = Get-AzRecoveryServicesBackupContainer -ContainerType "AzureVM"

        foreach ($container in $containers) {
            # Get backup items in the container
            $items = Get-AzRecoveryServicesBackupItem -Container $container -WorkloadType "AzureVM"

            foreach ($item in $items) {
                $vmInfo = [PSCustomObject]@{
                    SubscriptionName = $sub.Name
                    SubscriptionId   = $sub.Id
                    VaultName        = $vault.Name
                    VMName           = $item.FriendlyName
                    ResourceGroup    = $container.FriendlyName.Split("/")[0]
                    BackupStatus     = $item.ProtectionStatus
                    LastBackupTime   = $item.LastBackupTime
                }
                $protectedVMs += $vmInfo
            }
        }
    }
}

# Export to CSV
$protectedVMs | Export-Csv -Path "AzureVMsWithBackup.csv" -NoTypeInformation
