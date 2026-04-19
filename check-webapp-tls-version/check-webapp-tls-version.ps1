# This PowerShell script checks the minimum TLS Version of Azure Web apps in a given subscription
# Valuable when upgrading Web apps to the minimum supported TLS 1.2 version for security reasons

Connect-AzAccount -Tenant xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx

Set-AzContext -Subscription 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'

$apps = Get-AzWebApp
$names = $apps.Name

foreach($name in $names){
    $tls = (Get-AzWebApp -Name $name).SiteConfig.MinTlsVersion
    Write-Host "minTlsVersion of web app" $name "is" $tls
}
