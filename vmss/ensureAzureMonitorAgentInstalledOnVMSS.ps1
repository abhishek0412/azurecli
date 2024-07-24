<#
.SYNOPSIS
Ensures that the Azure Monitor Agent is installed on specified Windows Virtual Machine Scale Sets (VMSS).

.DESCRIPTION
This PowerShell script iterates through a predefined list of Windows VMSS and ensures that the Azure Monitor Agent is installed on each VMSS. It uses the Azure CLI to check the installation status and installs the agent if necessary.

.PARAMETER vmssList
An array of hashtable entries, each containing the 'ResourceGroup' and 'VmssName'. This parameter is mandatory and must be provided when calling the function.

.EXAMPLE
.\EnsureAzureMonitorAgentInstalledOnVMSS.ps1

This example demonstrates how to run the script, which ensures the Azure Monitor Agent is installed on the VMSS defined in the $vmssList variable. Ensure that the $vmssList variable is populated with the correct VMSS names and their corresponding resource groups before running the script.

.NOTES
- Ensure you have the Azure CLI installed and are authenticated to Azure with 'az login' before running this script.
- The script checks if each VMSS exists before attempting to install the Azure Monitor Agent. If a VMSS does not exist, a message is displayed, and the script continues to the next VMSS in the list.

#>

# List of VMSS with their resource groups
$vmssList = @(
    @{ ResourceGroup = "myResourceGroup"; VmssName = "myVMSS1" },
    @{ ResourceGroup = "myResourceGroup"; VmssName = "myVMSS2" }
)

# Function to ensure the Azure Monitor Agent is installed on specified VMSS
function Ensure-AzureMonitorAgentInstalledOnVMSS {
    param (
        [Parameter(Mandatory = $true)]
        [Array]$vmssList
    )

    foreach ($vmss in $vmssList) {
        $resourceGroup = $vmss.ResourceGroup
        $vmssName = $vmss.VmssName

        # Check if the VMSS exists
        $vmssExists = az vmss show --name $vmssName --resource-group $resourceGroup --query "name" -o tsv

        if ($vmssExists) {
            Write-Output "VMSS $vmssName found in resource group $resourceGroup."

            # Check if the Azure Monitor Agent is installed
            $agentStatus = az vmss extension show --resource-group $resourceGroup --vmss-name $vmssName --name AzureMonitorWindowsAgent --query "provisioningState" -o tsv

            if ($agentStatus -ne "Succeeded") {
                Write-Output "Installing Azure Monitor Agent on VMSS $vmssName in resource group $resourceGroup."

                # Install the Azure Monitor Agent
                az vmss extension set `
                    --resource-group $resourceGroup `
                    --vmss-name $vmssName `
                    --name AzureMonitorWindowsAgent `
                    --publisher Microsoft.Azure.Monitor `
                    --protected-settings '{"workspaceId":"<WorkspaceId>","workspaceKey":"<WorkspaceKey>"}'

                Write-Output "Installed Azure Monitor Agent on VMSS $vmssName."
            } else {
                Write-Output "Azure Monitor Agent is already installed on VMSS $vmssName."
            }
        } else {
            Write-Output "VMSS $vmssName not found in resource group $resourceGroup."
        }
    }
}

# Call the function and pass the list of VMSS
Ensure-AzureMonitorAgentInstalledOnVMSS -vmssList $vmssList
