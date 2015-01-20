##########################################################################################################
#            Author: David Rowe                            
#              Name: LogOutApplication.ps1                                          	                 #
#           Version: 1.0                                                                                 #
#     Creation date: 03-18-2013                                                                          #
#     Revision date: 03-18-2013                                                                          #
#           Purpose: Allows user to log their account out of an application		                         #
#       Description: Script creates a variable based on user input.  If user input = username, the       #
#		     Logout process begins. Publish this application a set of servers that are different than the#
#			servers the users are running the application.												 #
#     Modifications: Please contact author for any script modifications, except for portions of          #
#                    the script designed for such purpose                                                #
##########################################################################################################
#setuser - user must have access to log onto citrix console and logoff users - full admin access not required
$username="Domain\XenAppHelpDesk"
$a = (Get-Host).UI.RawUI
$a.BackgroundColor = "blue"
$a.WindowTitle = "Application Exit"
cls
Write-Host "Starting self service Logoff Process.  Please Wait..."
Write-Host "To cancel this process, please close this blue window."
C:

$checkuser = $null
#Get Credentials 
<#generate key and encrypted secret to password
$secret = 'myPASSWORD123'  
$key    = [Convert]::ToBase64String((1..32 |% { [byte](Get-Random -Minimum 0 -Maximum 255) }))  
$encryptedSecret = ConvertTo-SecureString -AsPlainText -Force -String $secret | ConvertFrom-SecureString -Key ([Convert]::FromBase64String($key))  
  
$encryptedSecret | Select-Object @{Name='Key';Expression={$key}},@{Name='EncryptedSecret';Expression={$encryptedSecret}} | fl  
#>
#store Creds
$key = "cJHUnKKdqZlqJ3SSr+SOCpBgOzTtARWnH9HDkAcYjjY="
$encryptedsecret = "76492d1116743f0423413b16050a5345MgB8ADMAbgBvAEgAQwA5AFMAbABOAGMAVgBTADkAeAB0AFoAbwB5AEIARgBzAHcAPQA9AHwAYgA0ADUAMABlADIAYgAzADQANgBhAGEAMgA5AGQANgA3AGYAYwBmADgAZgAxADUAYQBkAGMAOQA3AGQANQA4ADAAZABiAGUANwA3ADUAMQAyADcANgAzADkAOQBiADAANgBiAGIAZQAxADcANwBlADkAMwA5AGQAMQAyADYAZgA="
$ss = ConvertTo-SecureString -Key ([Convert]::FromBase64String($key)) -String $encryptedSecret 
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $ss

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

# Create AskUserName window
function AskUserName
{
$objForm = New-Object System.Windows.Forms.Form 
$objForm.Text = "User ID Verification"
$objForm.Size = New-Object System.Drawing.Size(300,240) 
$objForm.StartPosition = "CenterScreen"

$objForm.KeyPreview = $True
$objForm.Add_KeyDown({if ($_.KeyCode -eq "Enter") 
    {$checkuser=$objTextBox.Text;$objForm.Close()}})
$objForm.Add_KeyDown({if ($_.KeyCode -eq "Escape") 
    {$objForm.Close()}})

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Size(75,160)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = "OK"
$OKButton.Add_Click({$checkuser=$objTextBox.Text;$objForm.Close()})
$objForm.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Size(150,160)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = "Cancel"
$CancelButton.Add_Click({$checkuser='cancelled';$objForm.Close()})
$objForm.Controls.Add($CancelButton)

$objLabel = New-Object System.Windows.Forms.Label
$objLabel.Location = New-Object System.Drawing.Size(10,20) 
$objLabel.Size = New-Object System.Drawing.Size(260,40) 
$objLabel.Text = "Please correctly enter your user ID (121111, AB1234, sclause) in the space below:"
$objForm.Controls.Add($objLabel)

$objTextBox = New-Object System.Windows.Forms.TextBox 
$objTextBox.Location = New-Object System.Drawing.Size(10,60) 
$objTextBox.Size = New-Object System.Drawing.Size(260,20) 
$objForm.Controls.Add($objTextBox) 

$objLabel = New-Object System.Windows.Forms.Label
$objLabel.Location = New-Object System.Drawing.Size(10,100) 
$objLabel.Size = New-Object System.Drawing.Size(260,40) 
$objLabel.Text = "Clicking OK will log you out of Epic Hyperspace"
$objForm.Controls.Add($objLabel)

$objLabel = New-Object System.Windows.Forms.Label
$objLabel.Location = New-Object System.Drawing.Size(10,140) 
$objLabel.Size = New-Object System.Drawing.Size(260,40) 
$objLabel.Text = "Clicking OK will close your hung Hyperspace Session"
$objForm.Controls.Add($objLabel)

$objForm.Topmost = $True

$objForm.Add_Shown({$objForm.Activate()})
#set cursor in textbox
$handler = {$objForm.ActiveControl = $objTextBox}
  
# $handler = {$objTextbox1.Select()}

  $objForm.Add_Load($handler)  
[void] $objForm.ShowDialog()
CheckCreds
}

function CheckCreds
{
if("$checkuser.ToUpper()" -match "$env:username.ToUpper()")
{
"Username equals data entered."
"Please wait while Hyperspace closes"

#createItemToreaduser
#csv - stores username entered and passes it to the PS1 file launched by helpdeskuser
"Username">C:\tools\logmeuser.csv
$Env:username>>C:\tools\logmeuser.csv

#runscript as different user
#ps1 launch file - launched as xenapp admin user which logs off user account
Start-Process -Credential $cred C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "C:\Tools\powershell\XenAppUserLogoff\LogOutXenLaunch.ps1"



}
elseif($checkuser -eq 'cancelled')
{break}
elseif($checkuser -eq $null)
{AskUsername}
else
{
"Username DOES NOT EQUAL data entered"
AskUserName
}
}

#Checking if username = entered credentials
CheckCreds