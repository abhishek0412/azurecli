<#
.SYNOPSIS
Disables shared key access for a list of Azure Storage Accounts.

.DESCRIPTION
This PowerShell script iterates through a predefined list of Azure Storage Accounts and disables shared key access for each. It uses the Azure CLI to update the configuration of each Storage Account, setting the allowSharedKeyAccess property to false. This script ensures that shared key access is disabled for these Storage Accounts.

.PARAMETER accounts
An array of hashtable entries, each containing the 'ResourceGroup' and 'StorageAccount' name. This parameter is mandatory and must be provided when calling the function.

.EXAMPLE
.\DisableSharedKeyAccess.ps1

This example demonstrates how to run the script, which disables shared key access for the Storage Accounts defined in the $storageAccounts variable. Ensure that the $storageAccounts variable is populated with the correct Storage Account names and their corresponding resource groups before running the script.

.NOTES
- Ensure you have the Azure CLI installed and are authenticated to Azure with 'az login' before running this script.
- The script checks if each Storage Account exists before attempting to update its configuration. If a Storage Account does not exist, a message is displayed, and the script continues to the next Storage Account in the list.
- It's recommended to review the current configuration for each Storage Account before running this script to avoid unintentional access restrictions.

#>

# List of Storage Accounts with their Resource Groups
$storageAccounts = @(
    @{ ResourceGroup = "<example-rg>"; StorageAccount = "<example-sa>" }
)

# Function to disable shared key access for a list of storage accounts
function Disable-SharedKeyAccess {
    param (
        [Parameter(Mandatory = $true)]
        [Array]$accounts
    )

    foreach ($sa in $accounts) {
        $resourceGroup = $sa.ResourceGroup
        $storageAccount = $sa.StorageAccount

        # Check if the storage account exists
        $accountExists = az storage account check-name --name $storageAccount --query "nameAvailable" -o tsv

        if ($accountExists -eq "false") {
            Write-Output "Storage account $storageAccount found in resource group $resourceGroup."

            # Get the current configuration of the storage account
            $allowSharedKeyAccess = az storage account show --name $storageAccount --resource-group $resourceGroup --query "allowSharedKeyAccess" -o tsv

            # Check if allowSharedKeyAccess is not false
            if ($allowSharedKeyAccess -ne "false") {
                Write-Output "Updating $storageAccount in resource group $resourceGroup."

                # Update the storage account to set allowSharedKeyAccess to false
                az storage account update --name $storageAccount --resource-group $resourceGroup --set allowSharedKeyAccess=false

                Write-Output "Updated $storageAccount."
            } else {
                Write-Output "$storageAccount already has allowSharedKeyAccess set to false."
            }
        } else {
            Write-Output "Storage account $storageAccount not found in resource group $resourceGroup."
        }
    }
}

# Call the function and pass the list of storage accounts
Disable-SharedKeyAccess -accounts $storageAccounts
