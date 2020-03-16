#Run the LM settings commands on the hosts that will be part of the migration scenario
Set-VMHost -VirtualMachineMigrationAuthenticationType Kerberos -UseAnyNetworkForMigration $true

#Enable vm live migrations
Enable-VMMigration

#Add a subnet in the list of migration networks. Has effect if -UseAnyNetworkForMigration is $false
Add-VMMigrationNetwork -Subnet '192.168.1.0/24'

#Live migrate a VM to another host with all its VHD files and delete it from the source while keeping the destination default storage locations (shared nothing lm)
Move-VM -Name 'TestVM3' -DestinationHost 'HVS01.testcorp.com' -IncludeStorage