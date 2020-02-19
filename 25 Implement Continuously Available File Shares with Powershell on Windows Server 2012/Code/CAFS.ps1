#Install the fs role on both nodes
Add-WindowsFeature File-Services

###General file server
#Run directly on a cluster node (no remoting) to create a clustered general purpose file server
Add-ClusterFileServerRole -StaticAddress <ip> -Name 'FS01G' -Storage 'Cluster Disk 2'

#Create a highly available general purpose share
New-Item F:\TestShare -ItemType Directory
New-SmbShare -Name 'TestShare$' -Path F:\TestShare -ScopeName FS01G

###SOFS
#Add the disk 3 of the cluster to a CSV
Add-ClusterSharedVolume -Name 'Cluster Disk 3'
#Run this command directly on a cluster node with no remoting
Add-ClusterScaleOutFileServerRole -Name FS01SOFS
#Create a folder for the new share in the csv
New-Item C:\ClusterStorage\Volume2\TestSOFSShare -ItemType Directory
#create the share
New-SmbShare -Path C:\ClusterStorage\Volume2\TestSOFSShare -Name 'TestSOFSShare$' -ScopeName FS01SOFS
