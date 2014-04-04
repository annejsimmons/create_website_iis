I created this little script to automate the creation of websites in IIS. It’s written in powershell.

You will need to run this script in powershell thats running in Administrator Mode.

Prerequisites:
You will need to have .net installed.

Step 1 Loading the Web Administration Module

This script is using the WebAdministration module to do the creation and removal of websites. To be able to load this module before it runs my powershell script I create a .cmd file that I would call that would load this module and then call my main powershell script.

install_website.cmd

Step 2 Creating the main .ps1 script

Create a new script, I called mine install_website.ps1. I put mine next to my install_website.cmd.

install_website.ps1


As you can see I have two functions. One creates my website and associated app pool, the other removes it if it already exists. So I can run my script multiple times without a problem.

CreateWebsite, first sets up a new app pool, sets its ManagedRuntimeVersion to v4.0, creates a new website and then we also needed a sub application below that, so also sets that up.

For more information see http://annejsimmons.com/2013/09/02/creating-c-net-websites-in-iis-with-a-powershell-script/