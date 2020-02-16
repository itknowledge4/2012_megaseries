###Commands to run on the server hosting the iSCSI target
New-IscsiServerTarget -TargetName StorageForFS01
New-IscsiVirtualDisk -Path D:\iSCSI\Quorum.VHD -Size 1GB
Add-IscsiVirtualDiskTargetMapping -TargetName 'StorageForFS01' -Path D:\iSCSI\Quorum.VHD
New-IscsiVirtualDisk -Path D:\iSCSI\Data1.VHD -Size 2.5GB
Add-IscsiVirtualDiskTargetMapping -TargetName 'StorageForFS01' -Path D:\iSCSI\Data1.VHD
New-IscsiVirtualDisk -Path D:\iSCSI\Data2.VHD -Size 3GB
Add-IscsiVirtualDiskTargetMapping -TargetName 'StorageForFS01' -Path D:\iSCSI\Data2.VHD
#Permit the 2 servers to mount the LUNs from the target by their iscsi initiator addresses
set-IscsiServerTarget -TargetName 'StorageForFS01' -InitiatorIds 'IQN:iqn.1991-05.com.microsoft:fs01a.testcorp.com','IQN:iqn.1991-05.com.microsoft:fs01b.testcorp.com'
#Values that we can use for iniator ids are: DNSName, IPAddress, IPv6Address, IQN and MACAddress (DNSName:...)

###Commands to be run on both cluster nodes
Set-Service -Name MSiSCSI -StartupType Automatic
Start-Service MSiSCSI
Get-NetFirewallServiceFilter -Service msiscsi | Get-NetFirewallRule | Enable-NetFirewallRule
#use one of these commands to get the iscsi initiator address for the servers
iscsicli.exe
Get-InitiatorPort | select -ExpandProperty NodeAddress
#Start to connect the storage
New-IscsiTargetPortal -TargetPortalAddress bcm01
Get-IscsiTarget | Connect-IscsiTarget
#see if the disks have been mounted
Get-Disk
#To persiste the disks across reboots use this command
Get-IscsiSession | Register-IscsiSession

###Start installing and configuring cluster
#Run on both nodes to install feature
Install-WindowsFeature Failover-Clustering -IncludeManagementTools
#See all CmdLets
Get-Command -Module FailoverClusters

#Run the commands directly on one of the cluster nodes (not through ps remoting)
Test-Cluster -Node FS01A,FS01B
New-Cluster -Name FS01 -Node FS01A,FS01B -StaticAddress <ip>

#Set the cluster name to register a PTR record (recource has to be taken offline and online)
Get-ClusterResource -Name 'Cluster Name' | Set-ClusterParameter -Name PublishPTRRecords -Value 1

#Run the commands on one of the cluster nodes
#Format the quorum disk
Initialize-Disk -Number 1 -PartitionStyle GPT
New-Partition -DiskNumber 1 -UseMaximumSize -AssignDriveLetter
Format-Volume -DriveLetter E -FileSystem NTFS
#add it to the cluster
Get-Disk -Number 1 | Add-ClusterDisk
Set-ClusterQuorum -NodeAndDiskMajority 'Cluster Disk 1'
#Initialize the other 2 disks
Initialize-Disk -Number 2 -PartitionStyle GPT
Initialize-Disk -Number 3 -PartitionStyle GPT
New-Partition -DiskNumber 2 -UseMaximumSize -AssignDriveLetter
New-Partition -DiskNumber 3 -UseMaximumSize -AssignDriveLetter
Format-Volume -DriveLetter F -FileSystem NTFS -Force -Confirm:$false
Format-Volume -DriveLetter G -FileSystem NTFS -Force -Confirm:$false
Get-Disk -Number 2 | Add-ClusterDisk
Get-Disk -Number 3 | Add-ClusterDisk

###Notes
#On the server or client from where you use the failover cluster manager mmc snapin (2012 or W8)
#install Windows8-RT-KB2803748-x64 from: https://www.microsoft.com/en-us/download/details.aspx?id=36468