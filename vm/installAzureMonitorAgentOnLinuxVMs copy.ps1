<#
.SYNOPSIS
Installs the Azure Monitor Agent on specified Linux virtual machines.

.DESCRIPTION
This PowerShell script iterates through a predefined list of Linux virtual machines and installs the Azure Monitor Agent on each. It uses the Azure CLI to perform the installation.

.PARAMETER vmList
An array of hashtable entries, each containing the 'ResourceGroup' and 'VMName'. This parameter is mandatory and must be provided when calling the function.

.EXAMPLE
.\InstallAzureMonitorAgentOnLinuxVMs.ps1

This example demonstrates how to run the script, which installs the Azure Monitor Agent for the virtual machines defined in the $vmList variable. Ensure that the $vmList variable is populated with the correct VM names and their corresponding resource groups before running the script.

.NOTES
- Ensure you have the Azure CLI installed and are authenticated to Azure with 'az login' before running this script.
- The script checks if each VM exists before attempting to install the Azure Monitor Agent. If a VM does not exist, a message is displayed, and the script continues to the next VM in the list.

#>

# List of Linux VMs with their resource groups
$vmList = @(
    @{ ResourceGroup = "myResourceGroup"; VMName = "myLinuxVM1" },
    @{ ResourceGroup = "myResourceGroup"; VMName = "myLinuxVM2" }
)

# Function to install the Azure Monitor Agent on specified Linux VMs
function Install-AzureMonitorAgent {
    param (
        [Parameter(Mandatory = $true)]
        [Array]$vmList
    )

    foreach ($vm in $vmList) {
        $resourceGroup = $vm.ResourceGroup
        $vmName = $vm.VMName

        # Check if the VM exists
        $vmExists = az vm show --name $vmName --resource-group $resourceGroup --query "name" -o tsv

        if ($vmExists) {
            Write-Output "VM $vmName found in resource group $resourceGroup."

            # Install the Azure Monitor Agent extension
            Write-Output "Installing Azure Monitor Agent on VM $vmName in resource group $resourceGroup."

            az vm extension set \
                --resource-group $resourceGroup \
                --vm-name $vmName \
                --name AzureMonitorLinuxAgent \
                --publisher Microsoft.Azure.Monitoring \
                --version 1.0

            Write-Output "Azure Monitor Agent installed on VM $vmName."
        } else {
            Write-Output "VM $vmName not found in resource group $resourceGroup."
        }
    }
}

# Call the function and pass the list of VMs
Install-AzureMonitorAgent -vmList $vmList
