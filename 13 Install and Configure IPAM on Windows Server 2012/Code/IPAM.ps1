#Install IPAM
Install-WindowsFeature IPAM -IncludeManagementTools

#IPAM GPO provisioning
Invoke-IpamGpoProvisioning -Domain testcorp.com -GpoPrefixName ipam -IpamServerFqdn IPAM01.testcorp.com

#See a list of commands that are in the IPAM module
Get-Command -Module IpamServer

#Import IP addresses into IPAM
Import-IpamAddress -AddressFamily IPv4 -Path "C:\import.csv" -Force