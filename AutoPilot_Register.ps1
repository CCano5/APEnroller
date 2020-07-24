<#
. .\Test-WindowsEditionforAutopilot.ps1
. .\Get-DeviceSerial.ps1
. .\Connect-Tennant.ps1
. .\Test-AutoPilotforExistingDevice.ps1
#>
. C:\Users\jared\'OneDrive - Hillsborough Community College'\OIT\Deployment\Scripts\Test-AutopilotValidation.ps1

Test-WindowsEditionforAutopilot
$Serial = Get-DeviceSerial
Connect-Tennant
Test-AutopilotForExistingDevice -DeviceToCheck $Serial

$Group = Get-AzureADGroup -SearchString "ENDPOINT Devices" | Out-GridView -OutputMode Single

$confirmation = Read-Host "Next, the device info will be uploaded, registered with Windows AutoPilot and enrolled in AAD/MDM.  Continue? (Y/N) Default: Y"
if ($confirmation -eq 'n') {
    exit
}

<#
Install-Script -Name Get-WindowsAutoPilotInfo -Force
Get-WindowsAutoPilotInfo.ps1 -Online -Assign -AddToGroup ($Group.DisplayName) -reboot
Write-Host "Script has finished"
#>