#Sourcing functions from Functions-AutopilotValidation.ps1
iex(iwr https://raw.githubusercontent.com/JaredSeavyHodge/APEnroller/master/Functions-AutopilotValidation.ps1)

Test-WindowsEditionforAutopilot                             #Will Upgrade Home/Core Edition to Education to Support Autopilot
$Serial = Get-DeviceSerial                                  #Creates CimSession and Returns Device serial
Connect-Tennant                                             #Connects to Azure and MS-Graph - Imports Dependency Modules if Necessary
Test-AutopilotForExistingDevice -DeviceToCheck $Serial      #Check for Device Existence in Autopilot to Avoid Bug Behavior
Test-CheckForUnattendXML                                    #Will Remove any answerfiles in the Sysprep or Panther folder

if ((Read-Host "Do you want to remove any unattend files from this device? These answer files can sometimes cause issues. (Y/N) Default=N") -eq "Y"){
    Test-CheckForUnattendXML                                #Will check for and Remove any answerfiles in the Sysprep or Panther folders.
}

#Out-Grid for User to Select Azure Group to Add This Device Too
$Group = Get-AzureADGroup -SearchString "ENDPOINT Devices" | Out-GridView -OutputMode Single
$confirmation = Read-Host "The device info will be uploaded, registered with Windows AutoPilot, and enrolled in AAD/MDM.  Continue? (Y/N) Default: Y"
if ($confirmation -eq 'n') {
    exit
}

#Now that validations have completed, Micahel's script will be used to enroll the
#device into Windows Autopilot, Azure AD, and Intune MDM
#https://www.powershellgallery.com/packages/Get-WindowsAutoPilotInfo
#Author of Get-WindowsAutoPilotInfo:  Michael Niehaus
Install-Script -Name Get-WindowsAutoPilotInfo -Force
Get-WindowsAutoPilotInfo.ps1 -Online -Assign -AddToGroup ($Group.DisplayName) -reboot
Write-Host "Rebooting?"
