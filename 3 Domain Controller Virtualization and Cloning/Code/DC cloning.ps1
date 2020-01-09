#Add the new DC to the group for clonable DCs
Add-ADGroupMember 'Cloneable Domain Controllers' -Members 'CN=DC02,OU=Domain Controllers,DC=testcorp,DC=com'
#Make sure that you do not have anything that does not support DC cloning
Get-ADDCCloningExcludedApplicationList
#In case you get anything then it means that item is not supported for cloning
#You can generate an exclusion list
Get-ADDCCloningExcludedApplicationList -GenerateXml
#Generate a config file for cloning
New-ADDCCloneConfigFile -Static -IPv4Address 192.168.10.3 -IPv4DefaultGateway 192.168.10.254 -IPv4DNSResolver 192.168.10.1 -IPv4SubnetMask 255.255.255.0 -CloneComputerName DC03
#Now we stop the DC02 VM and export it
#Import VM
#Start the 2 domain controllers; after 2-3 minutes DC03 should appear as a DC in AD

Remove-ADGroupMember -Identity 'Cloneable Domain Controllers' -Members 'CN=DC02,OU=Domain Controllers,DC=testcorp,DC=com' -Confirm:$false
Remove-ADGroupMember -Identity 'Cloneable Domain Controllers' -Members 'CN=DC03,OU=Domain Controllers,DC=testcorp,DC=com' -Confirm:$false