# List of Key Vault names and their corresponding resource groups
$keyVaults = @(
    @{ Name = "Test"; ResourceGroup = "RG-Test" }
)

# Function to disable public network access for a Key Vault
function Disable-PublicNetworkAccess {
    param (
        [string]$vaultName,
        [string]$resourceGroupName
    )

    # Get the current Key Vault object
    $keyVault = Get-AzKeyVault -VaultName $vaultName -ResourceGroupName $resourceGroupName

    if ($keyVault) {
		# Disable public network access
		Update-AzKeyVaultNetworkRuleSet -DefaultAction Deny -VaultName $vaultName -ResourceGroupName $resourceGroupName -Bypass AzureServices
        Write-Output "Disabled public network access for Key Vault: $vaultName in Resource Group: $resourceGroupName"
    } else {
        Write-Output "Key Vault: $vaultName not found in Resource Group: $resourceGroupName"
    }
}

# Loop through each Key Vault and disable public network access
foreach ($kv in $keyVaults) {
    Disable-PublicNetworkAccess -vaultName $kv.Name -resourceGroupName $kv.ResourceGroup
}

