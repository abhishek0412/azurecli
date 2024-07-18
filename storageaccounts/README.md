# Disable Public Blob Access to Azure Storage Accounts

## Prerequisite

- Ensure you have the Azure CLI installed and are authenticated to Azure with `az login` before running this script.
- The script requires that the user has sufficient permissions to modify the network ACLs of the specified Storage Accounts.
- It's recommended to review the current network rules for each Storage Account before running this script to avoid unintentional access restrictions.
- The script includes a check to verify the existence of each Storage Account before attempting to update its network ACLs. This ensures that the script does not attempt to modify non-existent Storage Accounts, providing a cleaner execution and output.

## Script Explanation

1. **Authenticate to Azure**: The script uses `az login` to authenticate the user to Azure.
2. **List of Storage Accounts**: A list of Storage Account names and their resource groups is provided.
3. **Disable-PublicBlobAccess Function**: This function retrieves the current configuration for the Storage Account, updates its network rules to deny public blob access, and reapplies any existing IP rules and VNet rules.
4. **Loop Through Storage Accounts**: The script loops through each Storage Account in the list and disables public blob access.

## Running the Script

1. Save the script to a `.ps1` file, for example, `DisableAllowBlobPublicAccessStorageAccounts.ps1`.
2. Open a PowerShell window and navigate to the directory where the script is saved.
3. Execute the script:

   ```powershell
   .\DisableAllowBlobPublicAccessStorageAccounts.ps1