I created this little script to automate the creation of websites in IIS. It's written in powershell.

You will need to run this script in powershell thats running in Administrator Mode.

Prerequisites:
You will need to have .net installed.
<h2>Step 1 Loading the Web Administration Module</h2>
This script is using the WebAdministration module to do the creation and removal of websites. To be able to load this module before it runs my powershell script I create a .cmd file that I would call that would load this module and then call my main powershell script.

install_website.cmd

<pre><code>
powershell -executionpolicy remoteSigned -command import-module .\PSCommon\WebAdministration;.\install_website.ps1
</pre></code>
<h2>Step 2 Creating the main .ps1 script</h2>
Create a new script, I called mine install_website.ps1. I put mine next to my install_website.cmd.

install_website.ps1

<pre><code>
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
</pre></code>

As you can see I have two functions. One creates my website and associated app pool, the other removes it if it already exists. So I can run my script multiple times without a problem.

CreateWebsite, first sets up a new app pool, sets its ManagedRuntimeVersion to v4.0, creates a new website and then we also needed a sub application below that, so also sets that up.