#Create a GPO and enable Choose how bitlocker-protected fixed drivers can be recovered
#Update the policy on both nodes

#Install the bitlocker feature
Add-WindowsFeature BitLocker
#Restart both nodes (one by one)
Restart-Computer -Force

#If the disk that you want to encrypt is already used in the cluser it must be placed in maintenance mode
Get-ClusterSharedVolume “Cluster Disk 1” | Suspend-ClusterResource -Force

#Enable Bitlocker and backup the protector to AD
Enable-BitLocker 'C:\ClusterStorage\Volume1' -RecoveryPasswordProtector
$protectorId = (Get-BitLockerVolume 'C:\ClusterStorage\Volume1').Keyprotector | Where-Object {$_.KeyProtectorType -eq "RecoveryPassword"}
Backup-BitLockerKeyProtector 'C:\ClusterStorage\Volume1' -KeyProtectorId $protectorId.KeyProtectorId

#Run these commands directly on a node of the cluster
#Get the cluster name object
$cno = (Get-Cluster).name + '$'
#Add the cno to the disk as a protector so that the cluster can manage encryption and decryption
Add-BitLockerKeyProtector 'C:\ClusterStorage\Volume1' -ADAccountOrGroupProtector –ADAccountOrGroup $cno
######

#Resume using the volume
Get-ClusterSharedVolume 'Cluster Disk 2' | Resume-ClusterResource

#If you want to see the recovery info install thsi feature on a server with ADUC
Install-WindowsFeature RSAT-Feature-Tools-BitLocker-BdeAducExt