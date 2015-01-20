##########################################################################################################
#            Author: David Rowe 										                                 #
#              Name: LogOutXenLaunch.ps1                                         	 	                 #
#           Version: 1.0                                                                                 #
#     Creation date: 03-18-2013                                                                          #
#     Revision date: 03-18-2013                                                                          #
#           Purpose: To have user log themselves out of an application		                         		 #
#       Description: Script creates a variable based on user input.  If user input = username, the       #
#		     Logout process begins					                         #
#     Modifications: Please contact author for any script modifications, except for portions of          #
#                    the script designed for such purpose                                                #
##########################################################################################################
$a = (Get-Host).UI.RawUI
$a.BackgroundColor = "Blue"
$a.WindowTitle = "Hyperspace Exit"
cls
Write-Host "Searching for your session.  Please wait while I find you..."
$userslisted = Import-Csv 'C:\tools\logmeuser.csv'
#application Browsername - log user out of specified application.
$xenappAppname = "Application1"
Add-PSSnapin Citrix.XenApp.Commands

function LogoutHyperspace
{
"Found you! Beginning to log you out.  Please wait up to 30 seconds"
Get-XASession -BrowserName $xenappAppname |?{$_.AccountName -match $username.Username}|Stop-XASession
}

##Log User out from list
foreach ($username in $userslisted) {
LogoutHyperspace $username.Username
}
$a.BackgroundColor = "green"
$a.ForegroundColor = "black"
Write-Host "Previous hung session closed.  You are now able to launch your application.  Press any key to continue."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")