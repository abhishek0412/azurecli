<#
.SYNOPSIS
Ensures that the Azure Monitor Agent is installed on a list of Azure Windows virtual machines.

.DESCRIPTION
This PowerShell script iterates through a predefined list of Azure Windows virtual machines and ensures that the Azure Monitor Agent is installed on each. It uses the Azure CLI to check the installation status and install the agent if necessary.

.PARAMETER vms
An array of hashtable entries, each containing the 'ResourceGroup' and 'VmName'. This parameter is mandatory and must be provided when calling the function.

.EXAMPLE
.\EnsureAzureMonitorAgentInstalled.ps1

This example demonstrates how to run the script, which ensures the Azure Monitor Agent is installed on the virtual machines defined in the $vms variable. Ensure that the $vms variable is populated with the correct VM names and their corresponding resource groups before running the script.

.NOTES
- Ensure you have the Azure CLI installed and are authenticated to Azure with 'az login' before running this script.
- The script checks if each virtual machine exists before attempting to install the Azure Monitor Agent. If a virtual machine does not exist, a message is displayed, and the script continues to the next virtual machine in the list.

#>

# List of virtual machines with their resource groups
$vms = @(
    @{ ResourceGroup = "myResourceGroup"; VmName = "myVM1" },
    @{ ResourceGroup = "myResourceGroup"; VmName = "myVM2" }
)

# Function to ensure the Azure Monitor Agent is installed on a list of VMs
function Ensure-AzureMonitorAgentInstalled {
    param (
        [Parameter(Mandatory = $true)]
        [Array]$vms
    )

    foreach ($vm in $vms) {
        $resourceGroup = $vm.ResourceGroup
        $vmName = $vm.VmName

        # Check if the virtual machine exists
        $vmExists = az vm show --name $vmName --resource-group $resourceGroup --query "name" -o tsv

        if ($vmExists) {
            Write-Output "Virtual machine $vmName found in resource group $resourceGroup."

            # Check if the Azure Monitor Agent is installed
            $agentStatus = az vm extension list --vm-name $vmName --resource-group $resourceGroup --query "[?name=='AzureMonitorWindowsAgent'].provisioningState" -o tsv

            if ($agentStatus -ne "Succeeded") {
                Write-Output "Installing Azure Monitor Agent on $vmName in resource group $resourceGroup."

                # Install the Azure Monitor Agent
                az vm extension set `
                    --resource-group $resourceGroup `
                    --vm-name $vmName `
                    --name AzureMonitorWindowsAgent `
                    --publisher Microsoft.Azure.Monitor `
                    --protected-settings '{"workspaceId":"<WorkspaceId>","workspaceKey":"<WorkspaceKey>"}'

                Write-Output "Installed Azure Monitor Agent on $vmName."
            } else {
                Write-Output "Azure Monitor Agent is already installed on $vmName."
            }
        } else {
            Write-Output "Virtual machine $vmName not found in resource group $resourceGroup."
        }
    }
}

# Call the function and pass the list of virtual machines
Ensure-AzureMonitorAgentInstalled -vms $vms
