<#
.SYNOPSIS
Disables public blob access for a list of Azure Storage Accounts.

.DESCRIPTION
This PowerShell script iterates through a predefined list of Azure Storage Accounts and disables public blob access for each. It uses the Azure CLI to update the configuration of each Storage Account, setting the allowBlobPublicAccess property to false. This script ensures that blobs within these Storage Accounts are not publicly accessible.

.PARAMETER accounts
An array of hashtable entries, each containing the 'ResourceGroup' and 'StorageAccount' name. This parameter is mandatory and must be provided when calling the function.

.EXAMPLE
.\disableAllowBlobPublicAccessStorageAccounts.ps1

This example demonstrates how to run the script, which disables public blob access for the Storage Accounts defined in the $storageAccounts variable. Ensure that the $storageAccounts variable is populated with the correct Storage Account names and their corresponding resource groups before running the script.

.NOTES
- Ensure you have the Azure CLI installed and are authenticated to Azure with 'az login' before running this script.
- The script checks if each Storage Account exists before attempting to update its configuration. If a Storage Account does not exist, a message is displayed, and the script continues to the next Storage Account in the list.
- It's recommended to review the current configuration for each Storage Account before running this script to avoid unintentional access restrictions.

#>

# List of Storage Accounts with their Resource Groups
$storageAccounts = @(
    @{ ResourceGroup = "RG-Test"; StorageAccount = "test123abc" }
)

# Function to disable public blob access for a list of storage accounts
function Disable-PublicBlobAccess {
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
            $allowBlobPublicAccess = az storage account show --name $storageAccount --resource-group $resourceGroup --query "allowBlobPublicAccess" -o tsv

            # Check if allowBlobPublicAccess is not false
            if ($allowBlobPublicAccess -ne "false") {
                Write-Output "Updating $storageAccount in resource group $resourceGroup."

                # Update the storage account to set allowBlobPublicAccess to false
                az storage account update --name $storageAccount --resource-group $resourceGroup --set allowBlobPublicAccess=false

                Write-Output "Updated $storageAccount."
            } else {
                Write-Output "$storageAccount already has allowBlobPublicAccess set to false."
            }
        } else {
            Write-Output "Storage account $storageAccount not found in resource group $resourceGroup."
        }
    }
}

# Call the function and pass the list of storage accounts
Disable-PublicBlobAccess -accounts $storageAccounts