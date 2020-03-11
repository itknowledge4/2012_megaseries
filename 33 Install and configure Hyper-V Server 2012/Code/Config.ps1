Set-VMHost -VirtualHardDiskPath 'C:\VMs' -VirtualMachinePath 'C:\VMs'
#Create a new private switch
New-VMSwitch -Name 'TestSW' -SwitchType Private