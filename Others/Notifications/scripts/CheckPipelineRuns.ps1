<#
.SYNOPSIS
    This script retrieves and filters Azure DevOps pipeline runs from the past week.

.DESCRIPTION
    The script sets the default Azure DevOps organization and project, retrieves the list of pipeline runs for a specified pipeline, 
    and filters the runs to find those that were completed in the past week. It then outputs the details of these runs.

.PARAMETER organization
    The Azure DevOps organization name.

.PARAMETER project
    The Azure DevOps project name.

.PARAMETER pipelineId
    The ID of the pipeline.

.EXAMPLE
    .\CheckPipelineRuns.ps1 -organization "myOrg" -project "myProject" -pipelineId 42

.NOTES
    Ensure that Azure CLI is installed and you are logged in to your Azure DevOps account.
#>
param (
    [string]$organization,
    [string]$project,
    [int]$pipelineID
)
az devops login
# Set Azure DevOps defaults
az devops configure --defaults organization=$organization project=$project

# Get the list of pipeline runs
$runs = az pipelines runs list --pipeline-id $pipelineID --output json | ConvertFrom-Json
$days = 7
# Calculate the date one week ago
$dateOneWeekAgo = (Get-Date).AddDays(-$days).ToString("yyyy-MM-ddTHH:mm:ss.ffffffK")

# Filter runs based on created time and status
$recentCompletedRuns = $runs | Where-Object { 
    ([DateTime]$_.'startTime' -ge [DateTime]$dateOneWeekAgo) -and ($_.status -eq 'completed')
}

if (($recentCompletedRuns | Measure-Object).Count -gt 0) {
    Write-Output "Pipeline has run and completed in the past $days days."
    $recentCompletedRuns | ForEach-Object {
        Write-Output "Run Name: $($_.definition.name), Run ID: $($_.id), Status: $($_.status), Queue Time: $($_.queueTime), Start Time: $($_.startTime), Completed Time: $($_.finishTime)"
    }
} else {
    throw "Pipeline $($_.definition.name) has not run and completed in the past $days days."
}
