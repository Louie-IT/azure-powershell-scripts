# Description: Script to remove Log Analytic agents from Azure Virtual Machines. This is part of the "Retirement: Log Analytics Agent in Azure Monitor on 31 August 2024". 
# Author: Louie
# Date: 24/07/2024
# The virtual machines must be up and running.
# Else you will receive an error message "Cannot modify extensions in the VM when the VM is not running."

# Connecting to the Azure tenant and its subscription
Connect-AzAccount -Tenant xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx

$subscriptionId = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

Set-AzContext -SubscriptionId $subscriptionId

# Define an array of resource group names
# Replace with your actual resource group names
$resourceGroups = @('ResourceGroup1', 'ResourceGroup2', 'ResourceGroup3', 'ResourceGroup4')

# Define the VM extension name you want to remove
# Replace with the actual extension name if different
$extensionName = 'MicrosoftMonitoringAgent' 

# Loop through each resource group
foreach ($resourceGroup in $resourceGroups) {
    # Retrieve all VMs in the current resource group
    $vms = Get-AzVM -ResourceGroupName $resourceGroup

    # Loop through each VM in the resource group
    foreach ($vm in $vms) {
        # Remove the extension from the VM
        Remove-AzVMExtension -ResourceGroupName $resourceGroup -VMName $vm.Name -Name $extensionName -Force
    }
}

# Output the result
Write-Output "Azure Log Analytics agents have been removed from VMs in the listed resource groups."
