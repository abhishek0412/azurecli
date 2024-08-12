<#
.SYNOPSIS
    This script checks the status of a specified Azure DevOps agent and sends a notification if the agent is offline.

.DESCRIPTION
    The script uses Azure CLI to configure the default organization and project, retrieves the details of a specified agent, and checks its status. 
    If the agent is offline, it sends a notification to a specified Teams Channel.

.PARAMETER organization
    The Azure DevOps organization name.

.PARAMETER project
    The Azure DevOps project name.

.PARAMETER poolID
    The ID of the agent pool.

.PARAMETER agentID
    The ID of the agent.

.EXAMPLE
    .\agents.ps1 -organization "myOrg" -project "myProject" -poolID 1 -agentID 123

.NOTES
    Ensure that Azure CLI is installed and you are logged in to your Azure DevOps account.
#>
param (
    [string]$organization,
    [string]$project,
    [int]$poolID,
    [int]$agentID
)
az devops login

az devops configure --defaults organization=$organization project=$project

# Get agent details
$agent = az pipelines agent show --id $agentID --pool-id $poolID --include-assigned-request true --include-last-completed-request true --output json | ConvertFrom-Json

# Check if the agent status is not online
if ($agent.status -ne "online") {
    throw "Agent '$($agent.name)' is offline."
} else {
    Write-Output "Agent '$($agent.name)' is online."
}
