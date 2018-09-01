#Access Api
Import-Module STProtect

#Load Groups from Ivanti
$Groups = Get-Content -Path 

#Scan Group of Servers
foreach($i in $Groups) 
{

#Patching Code
$Patching = Start-PatchScan -TemplateName "Scan" –MachineGroups $i
$Patching | Watch-PatchScan -ErrorAction silentlycontinue
$Patching | Wait-PatchScan
$Patching | Start-PatchDeploy -TemplateName "ManualReboot"


$Results = $Patching | Watch-PatchScan
$Missing = $Results | Where {($_.MissingPatches -gt 0)} | Select Name, MissingPatches 
 
#Results of Scan
$Missing | Out-File ''
$Results  | Out-File -FilePath 
#Get Scan Data
$ScanInfo = Get-Content -Path 
#Piped Results
$BodyInfo = $ScanInfo | Out-String
 #Send Email with Scan Results
$recipients = @("")
$To = $recipients
$message = "$i `n Servers Missing Patches`n $BodyInfo "
Send-MailMessage -To $To -from  -Subject 'Ivanti Patch Scan' -Body $message  -SmtpServer smtp.whatever.com
}
