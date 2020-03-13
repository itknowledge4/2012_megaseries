#VM export and import
#Export VM to a path that will be created at export time
Export-VM -Path 'C:\Export' -Name 'TestVM2'
#Import VM and keep the files exactly where they are
Import-VM -Path 'C:\Import\TestVM2\Virtual Machines\{id}.XML'
#Import VM and copy the files to the default locations (VHDs may be put directly in the configured location)
Import-VM -Path 'C:\Import\TestVM2\Virtual Machines\{id}.XML' -Copy
#Import VM and copy the files to the default locations (specify a location for the disk files)
Import-VM -Path 'C:\Import\TestVM2\Virtual Machines\{id}.XML' -Copy -VhdDestinationPath 'C:\VMs\Virtual Machines'
