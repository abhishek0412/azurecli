<#
.SYNOPSIS
Disables public network access for a list of Azure Key Vaults.

.DESCRIPTION
This PowerShell script iterates through a predefined list of Azure Key Vaults and disables public network access for each. It uses the Azure CLI to update the network ACLs of each Key Vault, setting the default action to deny access from public networks. The script checks if each Key Vault exists before attempting to update it.

.PARAMETER keyVaults
An array of hashtable entries, each containing the 'Name' and 'ResourceGroup' of the Key Vault. This parameter is mandatory and must be provided when calling the function. The script will iterate through each entry in this array to disable public network access for the specified Key Vaults.

.EXAMPLE
.\DisablePublicAccessAzureKeyVaults.ps1

This example demonstrates how to run the script, which disables public network access for the Key Vaults defined in the $keyVaults variable. Ensure that the $keyVaults variable is populated with the correct Key Vault names and their corresponding resource groups before running the script.

.NOTES
- Ensure you have the Azure CLI installed and are authenticated to Azure with 'az login' before running this script.
- The script requires that the user has sufficient permissions to modify the network ACLs of the specified Key Vaults.
- It's recommended to review the current network rules for each Key Vault before running this script to avoid unintentional access restrictions.
- The script includes a check to verify the existence of each Key Vault before attempting to update its network ACLs. This ensures that the script does not attempt to modify non-existent Key Vaults, providing a cleaner execution and output.
#>

# List of Key Vault names and their corresponding resource groups
$keyVaults = @(
    @{ Name = "<keyvault-name>"; ResourceGroup = "<resourecegroup-name>" }
)

# Function to disable public network access for a list of Key Vaults using Azure CLI
function Disable-PublicNetworkAccess {
    param (
        [parameter(Mandatory = $true)]
        [array]$keyVaults
    )

    foreach ($kv in $keyVaults) {
        $vaultName = $kv.Name
        $resourceGroupName = $kv.ResourceGroup

        # Check if the specified Key Vault exists
        $existingVault = az keyvault show --name $vaultName --resource-group $resourceGroupName --query 'name' -o tsv

        if ($existingVault) {
            # Check if public network access is enabled
            $publicNetworkAccess = az keyvault show --name $vaultName --resource-group $resourceGroupName --query 'properties.networkAcls.defaultAction' -o json | ConvertFrom-Json

            if ($publicNetworkAccess -ne "Deny") {
                # Update the network ACLs to disable public access
                az keyvault update --name $vaultName --resource-group $resourceGroupName --default-action Deny
                Write-Output "Disabled public network access for Key Vault: $vaultName in Resource Group: $resourceGroupName"

            } else {
                Write-Output "Public network access is already disabled for Key Vault: $vaultName in Resource Group: $resourceGroupName"
            }
        } else {
            Write-Output "Key Vault: $vaultName not found in Resource Group: $resourceGroupName"
        }
    }
}

# Call the function and pass $keyVaults as parameter
Disable-PublicNetworkAccess -keyVaults $keyVaults
