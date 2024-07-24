<#
.SYNOPSIS
Disables public network access for specified Azure Cosmos DB accounts if it is not already disabled.

.DESCRIPTION
This PowerShell script iterates through a predefined list of Azure Cosmos DB accounts and disables public network access if it is currently enabled. It uses the Azure CLI to perform the configuration update.

.PARAMETER accounts
An array of hashtable entries, each containing the 'ResourceGroup' and 'CosmosDBAccountName'. This parameter is mandatory and must be provided when calling the function.

.EXAMPLE
.\DisablePublicNetworkAccessCosmosDB.ps1

This example demonstrates how to run the script, which disables public network access for the Cosmos DB accounts defined in the $cosmosDBAccounts variable. Ensure that the $cosmosDBAccounts variable is populated with the correct Cosmos DB account names and their corresponding resource groups before running the script.

.NOTES
- Ensure you have the Azure CLI installed and are authenticated to Azure with 'az login' before running this script.
- The script checks if each Cosmos DB account exists before attempting to update its configuration. If an account does not exist, a message is displayed, and the script continues to the next account in the list.

#>

# List of Cosmos DB accounts with their resource groups
$cosmosDBAccounts = @(
    @{ ResourceGroup = "myResourceGroup"; CosmosDBAccountName = "myCosmosDB1" },
    @{ ResourceGroup = "myResourceGroup"; CosmosDBAccountName = "myCosmosDB2" }
)

# Function to disable public network access for specified Cosmos DB accounts
function Disable-PublicNetworkAccess {
    param (
        [Parameter(Mandatory = $true)]
        [Array]$accounts
    )

    foreach ($account in $accounts) {
        $resourceGroup = $account.ResourceGroup
        $cosmosDBAccountName = $account.CosmosDBAccountName

        # Check if the Cosmos DB account exists
        $accountExists = az cosmosdb show --name $cosmosDBAccountName --resource-group $resourceGroup --query "name" -o tsv

        if ($accountExists) {
            Write-Output "Cosmos DB account $cosmosDBAccountName found in resource group $resourceGroup."

            # Get the current configuration of public network access
            $enablePublicNetworkAccess = az cosmosdb show --name $cosmosDBAccountName --resource-group $resourceGroup --query "enablePublicNetworkAccess" -o tsv

            if ($enablePublicNetworkAccess -eq "true") {
                Write-Output "Public network access is currently enabled for Cosmos DB account $cosmosDBAccountName."

                # Disable public network access
                Write-Output "Disabling public network access for Cosmos DB account $cosmosDBAccountName."

                az cosmosdb update --name $cosmosDBAccountName --resource-group $resourceGroup --set enablePublicNetworkAccess=false

                Write-Output "Public network access disabled for Cosmos DB account $cosmosDBAccountName."
            } else {
                Write-Output "Public network access is already disabled for Cosmos DB account $cosmosDBAccountName."
            }
        } else {
            Write-Output "Cosmos DB account $cosmosDBAccountName not found in resource group $resourceGroup."
        }
    }
}

# Call the function and pass the list of Cosmos DB accounts
Disable-PublicNetworkAccess -accounts $cosmosDBAccounts
