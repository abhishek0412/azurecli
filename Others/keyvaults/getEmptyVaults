# Get all Key Vaults in the subscription
$keyVaults = Get-AzKeyVault

# Initialize an array to hold key vaults without keys, secrets, or certificates
$emptyKeyVaults = @()

foreach ($kv in $keyVaults) {
    # Get the key vault name
    $vaultName = $kv.VaultName

    # Get the number of keys, secrets, and certificates
    $keys = Get-AzKeyVaultKey -VaultName $vaultName -ErrorAction SilentlyContinue
    $secrets = Get-AzKeyVaultSecret -VaultName $vaultName -ErrorAction SilentlyContinue
    $certificates = Get-AzKeyVaultCertificate -VaultName $vaultName -ErrorAction SilentlyContinue

    if (-not $keys -and -not $secrets -and -not $certificates) {
        $emptyKeyVaults += [PSCustomObject]@{
            VaultName = $vaultName
            ResourceGroupName = $kv.ResourceGroupName
            Location = $kv.Location
        }
    }
}

# Export the results to a CSV file
$emptyKeyVaults | Export-Csv -Path "EmptyKeyVaults.csv" -NoTypeInformation

Write-Host "The list of empty Key Vaults has been exported to EmptyKeyVaults.csv"
