function Extract-ZipFilesRecursively {
    param (
        [string]$sourceFolder
    )

    $zipFiles = Get-ChildItem -Path $sourceFolder -Filter *.zip -Recurse

    foreach ($zipFile in $zipFiles) {
        $extractPath = Join-Path -Path $sourceFolder -ChildPath ($zipFile.BaseName)
        # Ensure the extraction path exists
        if (-not (Test-Path -Path $extractPath)) {
            New-Item -ItemType Directory -Path $extractPath -Force
        }
        # Extract the zip file
        Expand-Archive -Path $zipFile.FullName -DestinationPath $extractPath -Force
        # Recursively call this function to handle any nested zip files
        Extract-ZipFilesRecursively -sourceFolder $extractPath
    }
}

# Initial call to the recursive function
$sourceFolder = 'C:\C\Zipped' 
$tempFolder = 'C:\temp\UnzippedFiles' 

if (-not (Test-Path -Path $tempFolder)) {
    New-Item -ItemType Directory -Path $tempFolder
}

# Copy all zip files to the temp folder to avoid modifying the original files
Get-ChildItem -Path $sourceFolder -Filter *.zip | Copy-Item -Destination $tempFolder

# Start the recursive extraction process
Extract-ZipFilesRecursively -sourceFolder $tempFolder