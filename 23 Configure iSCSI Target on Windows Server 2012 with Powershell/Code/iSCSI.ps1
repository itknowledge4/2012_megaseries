Install-WindowsFeature FS-iSCSITarget-Server

#Create a target, a disk and assign the disk to the target
New-IscsiServerTarget -TargetName TestStorage
New-IscsiVirtualDisk -Path D:\iSCSI\disk1.VHD -Size 1GB
Add-IscsiVirtualDiskTargetMapping -TargetName 'TestStorage' -Path D:\iSCSI\disk1.VHD

#Permit only a specific server to mount the disk from the newly created target
Set-IscsiServerTarget -TargetName 'TestStorage' -InitiatorIds 'IQN:iqn.1991-05.com.microsoft:bcs01.testcorp.com'
#To get the IQN just use the command: iscsicli

#####Run the following commands on the iSCSI iniator host
#Prepare the initiator
Set-Service -Name MSiSCSI -StartupType Automatic
Start-Service MSiSCSI
Get-NetFirewallServiceFilter -Service msiscsi | Get-NetFirewallRule | Enable-NetFirewallRule

#Connect to the target and mount the disks
New-IscsiTargetPortal -TargetPortalAddress bcm01
Get-IscsiTarget | Connect-IscsiTarget
#see if the disk has been mounted
Get-Disk