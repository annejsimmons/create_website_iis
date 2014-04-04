C:\Windows\Microsoft.NET\Framework\v4.0.30319\aspnet_regiis.exe -i

$website_name = "MyWebsite"
$website_source_directory = resolve-path "..\MyWebsite"
$website_virtual_directory = "IIS:\Sites\MyWebsite"

$app_pool_name = "MyWebsite_AppPool"
$app_pool_virtual_directory = "IIS:\AppPools\MyWebsite_AppPool"

$sub_application_name = "SubApplication"
$sub_application_source_directory = resolve-path "..\MyWebsite.SubApplication"

Function CreateWebsite {
 New-WebAppPool $app_pool_name
 Set-ItemProperty $app_pool_virtual_directory managedRuntimeVersion v4.0
 New-Website -Name "$website_name" -PhysicalPath $website_source_directory -ApplicationPool "$app_pool_name" -Port 8082 -Force
 New-WebApplication -Name "$sub_application_name" -Site "$website_name" -PhysicalPath $sub_application_source_directory -ApplicationPool $app_pool_name
}

Function RemoveWebsite($app_pool_virtual_directory, $site_virtual_directory, $website_name){
 if (Test-Path $app_pool_virtual_directory){
   $webSite = Get-Item $site_virtual_directory
 if ((Get-WebsiteState -Name "$website_name").Value -ne "Stopped") {
   $webSite.Stop()
 }
 $poolName = $webSite.applicationPool
 $pool = Get-Item "IIS:\AppPools\$poolName"
 if ((Get-WebAppPoolState -Name $poolName).Value -ne "Stopped") {
   $pool.Stop()
 }
 Remove-Website -Name "$website_name"
 Remove-WebAppPool -Name $poolName
 }
}

RemoveWebsite $app_pool_virtual_directory $website_virtual_directory $website_name
CreateWebsite