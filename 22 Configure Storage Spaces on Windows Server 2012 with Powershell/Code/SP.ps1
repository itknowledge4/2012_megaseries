#Get a list of disks that can be used in a storage pool
Get-PhysicalDisk -CanPool $true

#Create a storage pool with 4 disks
New-StoragePool –FriendlyName StoragePool1 –PhysicalDisks (Get-PhysicalDisk PhysicalDisk1, PhysicalDisk2, PhysicalDisk3, PhysicalDisk4) -StorageSubSystemFriendlyName "Storage Spaces*"

#Get all created storage pools
Get-StoragePool -IsPrimordial $false

#Add a hot spare to the pool
Add-PhysicalDisk -StoragePoolFriendlyName 'StoragePool1' -PhysicalDisks (Get-PhysicalDisk PhysicalDisk6) -Usage HotSpare

#Create a 2 way mirror fixed disk
New-VirtualDisk -StoragePoolFriendlyName 'StoragePool1' -FriendlyName 'VirtualDisk1' -Size 2GB -ProvisioningType Fixed

#create a simple thin provisioned disk
New-VirtualDisk -StoragePoolFriendlyName 'StoragePool1' -FriendlyName 'VirtualDisk2' -ResiliencySettingName 'Simple' -Size 2GB -ProvisioningType Thin

#Add another data disk to the pool
Add-PhysicalDisk -StoragePoolFriendlyName 'StoragePool1' -PhysicalDisks (Get-PhysicalDisk PhysicalDisk5) -Usage AutoSelect

#Create a 3 way mirror disk
New-VirtualDisk -StoragePoolFriendlyName 'StoragePool1' -FriendlyName 'VirtualDisk3' -Size 3GB -ProvisioningType Thin -NumberOfDataCopies 3

#Create a parity disk
New-VirtualDisk -StoragePoolFriendlyName "StoragePool1" -FriendlyName "VirtualDisk4" -Size 2GB -ProvisioningType Fixed -ResiliencySettingName "Parity"

#Create a volume on one of the disks
Get-VirtualDisk –FriendlyName VirtualDisk2 | Get-Disk | Initialize-Disk -PartitionStyle GPT –Passthru | New-Partition –AssignDriveLetter –UseMaximumSize | Format-Volume -FileSystem ReFS -Confirm:$false