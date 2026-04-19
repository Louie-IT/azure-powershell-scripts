#  Author: Louie
#  Date: 06/03/2024
#  Description: Safely Deleting multiple Azure Resource Groups
#  There is no rollback from Resource Group deletion. This is a safe way to remove multiple ones at once.
#  Prerequisites: 
#  1. Role: at least Contributor role
#  2. Ensure you have the Az Azure Modules installed locally and are connected to the right tenant/subscription
#  3. List on a TXT file the Resource Group names (1 per line) you want to delete. 

# Connecting to the tenant & subscription
Connect-AzAccount -Tenant xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

Set-AzContext -Subscription xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# List of RGs (one per line)
$file = Get-ChildItem -Path (Read-Host -Prompt 'Enter path to the Resource Groups list')

$resourceGroups = Get-Content $file

# Run for each Resource Group listed in $file
foreach ($resourceGroup in $resourceGroups) {
     
     Write-Output "PROCESSING..." 


# Delete the Resource Groups. "-AsJob = Run cmdlet in the background" | "-Force = Remove a resource group without confirmation"
          Remove-AzResourceGroup -asJob -Force $resourceGroup

             Write-Output "DONE"
     
             Write-Host "`n"
}
