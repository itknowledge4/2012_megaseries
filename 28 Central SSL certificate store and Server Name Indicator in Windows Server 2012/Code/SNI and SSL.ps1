#On DC create a user with access to the store
#Also on DC (DNS server) make 3 aliases to the web server with names web1 web2 and web3

#On a file server create the share that will contain the certs
#Assign the created user read permissions and lock the security down
#\\DC01\SSLStore$

#Request 3 web site certs named web1, web2, web3
#Export the certs with the private key in pfx files and put them in the share
#When exporting set also a password on them
#Their names and subject should be the same as the web site addresses:
#web1.testcorp.com.pfx web2.testcorp.com.pfx and so on

#After exporting all certs you can delete them; to fully delete a cert with the private key do the following
dir Cert:\LocalMachine\My
#youwill get a list of certificate names and thumbprints
#For each thumbprint run the following
certutil -store my "<thumbprint>" | Where-Object {$_ -like '*Key Container*'}
certutil -delkey '<KeyContainerName>'
#After this you can also remove the certificates from the store
Remove-Item Cert:\LocalMachine\My\<thumbprint>

#On the web server install the web server role and also include the central ssl store support
Install-WindowsFeature Web-Server -IncludeManagementTools
Install-WindowsFeature Web-CertProvider
#Enable central store provider
Enable-WebCentralCertProvider -CertStoreLocation '\\BCM\SSLStore$' -UserName 'TESTCORP\User100' -Password 'pass' -PrivateKeyPassword 'pass'
#Settings are stored here
#HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\IIS\CentralCertProvider

#Make a new folder named sites and 3 subfolders web1 web2 and web3
mkdir C:\Sites
mkdir C:\Sites\web1
mkdir C:\Sites\web2
mkdir C:\Sites\web3

#In each folder make a file index.html with the following in it
#<h1>SiteX</h1> where X is 1 2 or 3
#Now let's create the 3 websites
New-Website -Name 'Web1' -Port 443 -HostHeader 'web1.testcorp.com' -PhysicalPath C:\Sites\web1 -Ssl -SslFlags 3
New-Website -Name 'Web2' -Port 443 -HostHeader 'web2.testcorp.com' -PhysicalPath C:\Sites\web2 -Ssl -SslFlags 3
New-Website -Name 'Web3' -Port 443 -HostHeader 'web3.testcorp.com' -PhysicalPath C:\Sites\web3 -Ssl -SslFlags 3
#Test the 3 sites from another domain machine. The certificates should be assigned