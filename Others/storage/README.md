# Disable Public Network Access to Azure Key Vaults

## Prerequisite

- Ensure you have the [Azure PowerShell](https://learn.microsoft.com/en-us/powershell/azure/install-azure-powershell?view=azps-12.1.0) module installed and are authenticated to Azure with `Connect-AzAccount` before running this script.
- The script requires that the user has sufficient permissions to modify the network ACLs of the specified Key Vaults.
- It's recommended to review the current network rules for each Key Vault before running this script to avoid unintentional access restrictions.
- The script includes a check to verify the existence of each Key Vault before attempting to update its network ACLs. This ensures that the script does not attempt to modify non-existent Key Vaults, providing a cleaner execution and output.

## Script Explanation

1. **Authenticate to Azure**: The script uses `Connect-AzAccount` to authenticate the user to Azure.
2. **List of Key Vaults**: A list of Key Vault names and their corresponding resource groups is provided.
3. **Disable-PublicNetworkAccess Function**: This function retrieves the current network rules for the Key Vault, updates its network rules to deny public access, and reapplies any existing IP rules and VNet rules.
4. **Loop Through Key Vaults**: The script loops through each Key Vault in the list and disables public network access.

## Running the Script

1. Save the script to a `.ps1` file, for example, `disablePublicAccessKeyVault.ps1`.
2. Open a PowerShell window and navigate to the directory where the script is saved.
3. Execute the script:

   ```powershell
   .\disablePublicAccessKeyVault.ps1
