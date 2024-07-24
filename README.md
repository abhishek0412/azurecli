# Azure Security Scripts

This repository contains PowerShell scripts for managing Azure resources with a focus on security compliance. Each script addresses specific security configurations for various Azure services.

## Scripts Overview

1. **Disable Public Blob Access for Storage Accounts**
   - **Script:** `DisablePublicBlobAccessStorageAccounts.ps1`
   - **Purpose:** Disables public blob access for Azure Storage Accounts to enhance security by ensuring that blobs are not publicly accessible.
   - **Parameters:**
     - `accounts`: An array of hashtable entries, each containing `ResourceGroup` and `StorageAccount` names.
   - **Usage:** Run the script and ensure that you have the Azure CLI installed and authenticated.

2. **Disable Shared Key Access for Storage Accounts**
   - **Script:** `DisableSharedKeyAccessStorageAccounts.ps1`
   - **Purpose:** Disables shared key access for Azure Storage Accounts to improve security by requiring the use of Azure Active Directory (AAD) for authentication.
   - **Parameters:**
     - `accounts`: An array of hashtable entries, each containing `ResourceGroup` and `StorageAccount` names.
   - **Usage:** Run the script and ensure that you have the Azure CLI installed and authenticated.

3. **Azure SQL Database - Enable Microsoft Entra-Only Authentication**
   - **Script:** `EnableEntraAuthenticationForSQLDatabases.ps1`
   - **Purpose:** Ensures that Microsoft Entra (formerly Azure AD) authentication is enabled for Azure SQL Databases to strengthen authentication security.
   - **Parameters:**
     - `databases`: An array of hashtable entries, each containing `ResourceGroup` and `SQLDatabaseName`.
   - **Usage:** Run the script and ensure that you have the Azure CLI installed and authenticated.

4. **Linux Virtual Machines - Install Azure Monitor Agent**
   - **Script:** `InstallAzureMonitorAgentOnLinuxVMs.ps1`
   - **Purpose:** Installs the Azure Monitor Agent on Linux Virtual Machines to enable monitoring and logging.
   - **Parameters:**
     - `vms`: An array of hashtable entries, each containing `ResourceGroup` and `VMName`.
   - **Usage:** Run the script and ensure that you have the Azure CLI installed and authenticated.

5. **Windows Virtual Machine Scale Sets - Install Azure Monitor Agent**
   - **Script:** `InstallAzureMonitorAgentOnWindowsVMSS.ps1`
   - **Purpose:** Installs the Azure Monitor Agent on Windows Virtual Machine Scale Sets to ensure monitoring and logging capabilities.
   - **Parameters:**
     - `vmss`: An array of hashtable entries, each containing `ResourceGroup` and `VMSSName`.
   - **Usage:** Run the script and ensure that you have the Azure CLI installed and authenticated.

6. **Azure Cosmos DB - Disable Public Network Access**
   - **Script:** `DisablePublicNetworkAccessCosmosDB.ps1`
   - **Purpose:** Disables public network access for Azure Cosmos DB accounts to enhance security by restricting network access to only specified virtual networks.
   - **Parameters:**
     - `cosmosDBAccounts`: An array of hashtable entries, each containing `ResourceGroup` and `CosmosDBAccountName`.
   - **Usage:** Run the script and ensure that you have the Azure CLI installed and authenticated.

7. **Ensure Azure Monitor Agent is Installed on Windows Virtual Machines**
   - **Script:** `EnsureAzureMonitorAgentOnWindowsVMs.ps1`
   - **Purpose:** Ensures that the Azure Monitor Agent is installed on a list of Azure Windows Virtual Machines.
   - **Parameters:**
     - `vms`: An array of hashtable entries, each containing `ResourceGroup` and `VMName`.
   - **Usage:** Run the script and ensure that you have the Azure CLI installed and authenticated.

8. **Disable Public Blob Access for Azure Storage Accounts**
   - **Script:** `DisablePublicBlobAccessForStorageAccounts.ps1`
   - **Purpose:** Disables public blob access for a list of Azure Storage Accounts to ensure blobs are not publicly accessible.
   - **Parameters:**
     - `accounts`: An array of hashtable entries, each containing `ResourceGroup` and `StorageAccount` names.
   - **Usage:** Run the script and ensure that you have the Azure CLI installed and authenticated.

9. **Set Network ACLs Default Action to "Deny" for Azure Storage Accounts**
   - **Script:** `SetNetworkACLsDefaultActionDeny.ps1`
   - **Purpose:** Sets the network ACLs default action to "Deny" for a list of Azure Storage Accounts to enforce stricter network access controls.
   - **Parameters:**
     - `accounts`: An array of hashtable entries, each containing `ResourceGroup` and `StorageAccount` names.
   - **Usage:** Run the script and ensure that you have the Azure CLI installed and authenticated.

## Prerequisites

- **Azure CLI:** Ensure that you have the Azure CLI installed and configured on your machine. You can download it from [Azure CLI Installation](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli).
- **Authentication:** Authenticate to your Azure account using `az login` before running any of these scripts.

## Running the Scripts

1. Save the relevant PowerShell script to your local machine.
2. Open a PowerShell terminal.
3. Navigate to the directory containing the script.
4. Execute the script using:
   ```powershell
   .\ScriptName.ps1
