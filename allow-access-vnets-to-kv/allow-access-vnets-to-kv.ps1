#  Author: Louie
#  Version: 1.0
#  Date: 12/08/2022
#  Description: Adding existing virtual networks as "Selected networks" allowing access from them to the key vaults listed in $file
#  
#  Note: Replace "*_VirtualNetwork_ResourceGroup_Name", "*_SYD_VirtualNetwork_Name", and "*_Subnet_Name" with the ones you want to add.

#List of Key Vaults (one per line)
$file = "C:\temp\vaults.txt"

$vaults = Get-Content $file

#Run over each Key Vault listed in $file
foreach ($vault in $vaults) {
     Write-output "Processing $($vault.vaultname)"

#Add existing virtual networks
     $subnet = Get-AzVirtualNetwork -ResourceGroupName "SYD_VirtualNetwork_ResourceGroup_Name" -Name "SYD_VirtualNetwork_Name" | Get-AzVirtualNetworkSubnetConfig -Name "SYD_Subnet_Name"
     Add-AzKeyVaultNetworkRule -VaultName $vault -VirtualNetworkResourceId $subnet.Id

     $subnet = Get-AzVirtualNetwork -ResourceGroupName "MEL_VirtualNetwork_ResourceGroup_Name" -Name "MEL_VirtualNetwork_Name" | Get-AzVirtualNetworkSubnetConfig -Name "MEL_Subnet_Name"
     Add-AzKeyVaultNetworkRule -VaultName $vault -VirtualNetworkResourceId $subnet.Id

     Write-output "Done"  
}
