function UnzipFiles($path) {
    Add-Type -AssemblyName System.IO.Compression.FileSystem

    $zipFiles = Get-ChildItem -Path $path -Filter "*.zip" -Recurse

    foreach ($zipFile in $zipFiles) {
        $zipFileDir = Split-Path -Path $zipFile.FullName -Parent
        Write-Host "Extracting: $($zipFile.FullName)"
        [System.IO.Compression.ZipFile]::ExtractToDirectory($zipFile.FullName, $zipFileDir)
        Remove-Item -Path $zipFile.FullName
    }

    $nestedZipFiles = Get-ChildItem -Path $path -Filter "*.zip" -Recurse

    if ($nestedZipFiles.Count -gt 0) {
        Write-Host "Found nested zip files. Extracting..."
        UnzipFiles($path)
    }
}

# Provide the path where your zip files are located
$zipPath = "C:\C\Test"

UnzipFiles($zipPath)