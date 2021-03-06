param(
    [Parameter(Mandatory)]
    $ResourceGroupName,

    [Parameter(Mandatory)]
    $ResourceGroupLocation
)

Write-Host "Creating resource group $ResourceGroupName in location $ResourceGroupLocation."
az group create -n $ResourceGroupName -l $ResourceGroupLocation

Write-Host 'Starting deployment of ARM template.'
$templateFilePath = Join-Path $PSScriptRoot 'template.json'
$deploymentOutputsJson = az group deployment create -j -g $ResourceGroupName --template-file $templateFilePath
$deploymentOutputs = $deploymentOutputsJson | ConvertFrom-Json
$functionAppName = $deploymentOutputs.properties.outputs.functionsAppName.value

Write-Host "Deploying to Azure Functions app $functionAppName."
$functionAppFolder = Join-Path $PSScriptRoot '..' 'src' 'invokesqlcmd-pwshfunc'
Push-Location $functionAppFolder
func azure functionapp publish $functionAppName
Pop-Location
