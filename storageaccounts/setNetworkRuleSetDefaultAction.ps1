<#
.SYNOPSIS
Sets the network ACLs default action to "Deny" for a list of Azure Storage Accounts.

.DESCRIPTION
This PowerShell script iterates through a predefined list of Azure Storage Accounts and sets the network ACLs default action to "Deny" for each. It uses the Azure CLI to update the configuration of each Storage Account, ensuring that only explicitly allowed traffic can access the storage account. This script enhances the security posture by restricting unintended network access.

.PARAMETER accounts
An array of hashtable entries, each containing the 'ResourceGroup' and 'StorageAccount' name. This parameter is mandatory and must be provided when calling the function. The script will iterate through each entry in this array to update the network ACLs default action for the specified Storage Accounts.

.EXAMPLE
.\Set-NetworkAclsDefaultAction.ps1

This example demonstrates how to run the script, which sets the network ACLs default action to "Deny" for the Storage Accounts defined in the $storageAccounts variable. Ensure that the $storageAccounts variable is populated with the correct Storage Account names and their corresponding resource groups before running the script.

.NOTES
- Ensure you have the Azure CLI installed and are authenticated to Azure with 'az login' before running this script.
- The script checks if each Storage Account exists before attempting to update its configuration. If a Storage Account does not exist, a message is displayed, and the script continues to the next Storage Account in the list.
- It's recommended to review the current network ACLs configuration for each Storage Account before running this script to avoid unintentional access restrictions.
- The script sets the networkRuleSet.defaultAction to "Deny" and bypasses AzureServices, allowing Azure services to still access the storage account. Adjust the bypass settings as necessary for your environment.

#>

# List of Storage Accounts with their Resource Groups
$storageAccounts = @(
    @{ ResourceGroup = "RG-Test"; StorageAccount = "test123abc" }
)

# Function to set networkAcls.defaultAction to "Deny" for a list of storage accounts
function Set-NetworkAclsDefaultAction {
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

            # Get the current network ACLs configuration of the storage account
            $networkRuleSet = az storage account show --name $storageAccount --resource-group $resourceGroup --query "networkRuleSet" -o json | ConvertFrom-Json
            
            # Check if networkRuleSet.defaultAction is not "Deny"
            if ($networkRuleSet.defaultAction -ne "Deny") {
                Write-Output "Updating $storageAccount in resource group $resourceGroup."

                # Update the storage account to set networkRuleSet.defaultAction to "Deny"
                az storage account update --name $storageAccount --resource-group $resourceGroup --default-action Deny --bypass AzureServices

                Write-Output "Updated $storageAccount."
            } else {
                Write-Output "$storageAccount already has networkRuleSet.defaultAction set to Deny."
            }
        } else {
            Write-Output "Storage account $storageAccount not found in resource group $resourceGroup."
        }
    }
}

# Call the function and pass the list of storage accounts
Set-NetworkAclsDefaultAction -accounts $storageAccounts
