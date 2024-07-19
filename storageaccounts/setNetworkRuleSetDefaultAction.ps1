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
