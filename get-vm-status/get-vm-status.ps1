# PowerShell script to check Azure virtual machine status.
# Ideal for tenants with a large number of VMs

$vm = Get-Azvm -Status

foreach($vms in $vm)
{
   $statuscheck = Get-AzVM -ResourceGroupName $vms.ResourceGroupName -Name $vms.Name -Status 
    if($statuscheck.Statuses.DisplayStatus[1] -eq "VM running")
    {  

        Write-Output "Stopping virtual machine...$($vms.Name)"

        Stop-AzVM -ResourceGroupName $vms.ResourceGroupName -Name $vms.Name -Force
    }   
    else
    {
        Write-output "Virtual machine $($vms.Name) is already in stopped state"
    }
}
