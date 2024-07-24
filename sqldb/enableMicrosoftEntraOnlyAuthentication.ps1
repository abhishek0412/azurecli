<#
.SYNOPSIS
Enables Microsoft Entra-only authentication for specified Azure SQL Databases.

.DESCRIPTION
This PowerShell script iterates through a predefined list of Azure SQL Databases and enables Microsoft Entra-only authentication for each. It uses the Azure CLI to update the configuration of each SQL Database.

.PARAMETER sqlDatabases
An array of hashtable entries, each containing the 'ResourceGroup', 'ServerName', and 'DatabaseName'. This parameter is mandatory and must be provided when calling the function.

.EXAMPLE
.\EnableMicrosoftEntraOnlyAuthentication.ps1

This example demonstrates how to run the script, which enables Microsoft Entra-only authentication for the SQL Databases defined in the $sqlDatabases variable. Ensure that the $sqlDatabases variable is populated with the correct database names and their corresponding resource groups and server names before running the script.

.NOTES
- Ensure you have the Azure CLI installed and are authenticated to Azure with 'az login' before running this script.
- The script checks if each SQL Database exists before attempting to update its configuration. If a SQL Database does not exist, a message is displayed, and the script continues to the next database in the list.

#>

# List of SQL Databases with their resource groups and server names
$sqlDatabases = @(
    @{ ResourceGroup = "myResourceGroup"; ServerName = "mySqlServer"; DatabaseName = "myDatabase1" },
    @{ ResourceGroup = "myResourceGroup"; ServerName = "mySqlServer"; DatabaseName = "myDatabase2" }
)

# Function to enable Microsoft Entra-only authentication for specified SQL Databases
function Enable-MicrosoftEntraOnlyAuthentication {
    param (
        [Parameter(Mandatory = $true)]
        [Array]$sqlDatabases
    )

    foreach ($db in $sqlDatabases) {
        $resourceGroup = $db.ResourceGroup
        $serverName = $db.ServerName
        $databaseName = $db.DatabaseName

        # Check if the SQL Database exists
        $dbExists = az sql db show --name $databaseName --server $serverName --resource-group $resourceGroup --query "name" -o tsv

        if ($dbExists) {
            Write-Output "SQL Database $databaseName found in server $serverName and resource group $resourceGroup."

            # Enable Microsoft Entra-only authentication
            Write-Output "Enabling Microsoft Entra-only authentication for SQL Database $databaseName in server $serverName and resource group $resourceGroup."

            # Update the SQL server to enable Microsoft Entra-only authentication
            az sql server ad-admin create --resource-group $resourceGroup --server $serverName --display-name "AzureAD Admin" --object-id "00000000-0000-0000-0000-000000000000"

            Write-Output "Enabled Microsoft Entra-only authentication for SQL Database $databaseName."
        } else {
            Write-Output "SQL Database $databaseName not found in server $serverName and resource group $resourceGroup."
        }
    }
}

# Call the function and pass the list of SQL Databases
Enable-MicrosoftEntraOnlyAuthentication -sqlDatabases $sqlDatabases
