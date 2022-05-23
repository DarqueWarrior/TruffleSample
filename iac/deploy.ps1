[CmdletBinding()]
param (
        [Parameter(
                Position = 0,
                HelpMessage = "The name of the resource group to be created. All resources will be place in the resource group and start with name."
        )]
        [string]
        $rgName = "TruffleSample_dev",

        [Parameter(
                Position = 1,
                HelpMessage = "The location to store the meta data for the deployment."
        )]
        [string]
        $location = "centralus",
        
        [string]
        $repoUrl,

        [switch]
        $deployGanache
)

Write-Verbose $repoUrl

Write-Output 'Deploying the Azure infrastructure'
Write-Output "Deploy Ganache: $($deployGanache.IsPresent)"

$deployment = $(az deployment sub create --name $rgName `
                --location $location `
                --template-file ./main.bicep `
                --parameters location=$location `
                --parameters rgName=$rgName `
                --parameters repoUrl=$repoUrl `
                --parameters deployGanache=$($deployGanache.IsPresent.ToString()) `
                --output json) | ConvertFrom-Json

# Store the outputs from the deployment
$swaName = $deployment.properties.outputs.swaName.value
$deploymentToken = $deployment.properties.outputs.deploymentToken.value

if ($deployGanache.IsPresent) {
        $ganacheIp = $deployment.properties.outputs.ganacheIp.value
        Write-Host "The IP of Ganache is $ganacheIp"
        Write-Host "##vso[task.setvariable variable=ganacheIp;isOutput=true]$ganacheIp"
}

# Write the values as output so they can be used in other stages.
# https://docs.microsoft.com/en-us/azure/devops/pipelines/process/expressions?view=azure-devops#dependencies
# https://docs.microsoft.com/en-us/azure/devops/pipelines/process/variables?view=azure-devops&tabs=yaml%2Cbatch#share-variables-across-pipelines
# https://docs.microsoft.com/en-us/azure/devops/pipelines/process/expressions?view=azure-devops#dependencies
Write-Host "##vso[task.setvariable variable=swaName;isOutput=true]$swaName"
Write-Host "##vso[task.setvariable variable=resourceGroup;isOutput=true]$rgName"
Write-Host "##vso[task.setvariable variable=deploymentToken;isOutput=true]$deploymentToken"