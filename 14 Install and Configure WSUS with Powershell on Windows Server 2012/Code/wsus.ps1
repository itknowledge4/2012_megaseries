#In this example my WSUS server uses a proxy to get to the internet

#Add the WSUS role and install the required roles/features
Install-WindowsFeature -Name UpdateServices -IncludeManagementTools

#Configure WSUS post install
#Create a directory for WSUS
New-Item 'C:\WSUS' -ItemType Directory
& 'C:\Program Files\Update Services\Tools\WsusUtil.exe' postinstall CONTENT_DIR=C:\WSUS

#Change different WSUS config items
$wsus = Get-WSUSServer
$wsusConfig = $wsus.GetConfiguration()
Set-WsusServerSynchronization –SyncFromMU
$wsusConfig.UseProxy=$true
$wsusConfig.ProxyName='192.168.1.254'
$wsusConfig.Save()
$wsusConfig.AllUpdateLanguagesEnabled = $false
$wsusConfig.SetEnabledUpdateLanguages(“en”)
$wsusConfig.Save()
$wsusConfig.TargetingMode='Client'
$wsusConfig.Save()
#Get WSUS Subscription and perform initial synchronization to get latest categories
$subscription = $wsus.GetSubscription()
$subscription.StartSynchronizationForCategoryOnly()
# $subscription.GetSynchronizationStatus() should not be Running to be done

$wsusConfig.OobeInitialized = $true
$wsusConfig.Save()

#Get only 2012 updates
Get-WsusProduct | Where-Object {$_.Product.Title -ne "Windows Server 2012"} | Set-WsusProduct -Disable
Get-WsusProduct | Where-Object {$_.Product.Title -eq "Windows Server 2012"} | Set-WsusProduct
#Get only specific classifications
Get-WsusClassification | Where-Object { $_.Classification.Title -notin 'Update Rollups','Security Updates','Critical Updates','Updates','Service Packs'  } | Set-WsusClassification -Disable
Get-WsusClassification | Where-Object { $_.Classification.Title -in 'Update Rollups','Security Updates','Critical Updates','Updates','Service Packs'  } | Set-WsusClassification

#Start a sync
$subscription.StartSynchronization()
$subscription.GetSynchronizationProgress()
$subscription.GetSynchronizationStatus()

#Other things that should be done are configure auto approval rules and sync times

#Create wsus target groups
#Create a GPO and set enable automatic updates, client side targeting and intranet wsus server
#Intranet address: http://wsus01.testcorp.com:8530


#Enable reports
#Install .NET 3.5 using the installation iso mounted in the virtual DVD drive (in this case)
Install-WindowsFeature NET-Framework-Core -Source D:\sources\sxs
#Install Microsoft report viewer redistributable 2008
#Get it from: https://www.microsoft.com/en-us/download/confirmation.aspx?id=6576
Start-Process -FilePath '.\ReportViewer 2008.exe' -ArgumentList '/q' -Wait

#Fix WSUS AppPool stopping constantly
#Click on APPLICATION POOLS
#Click on WSUSPOOL
#Click ADVANCED SETTINGS (action pane on right side)
#Scroll down and increase the PRIVATE MEMORY LIMIT (around 2GB worked in my case) and decrease the REGULAR TIME INTERVAL (240 minutes).
