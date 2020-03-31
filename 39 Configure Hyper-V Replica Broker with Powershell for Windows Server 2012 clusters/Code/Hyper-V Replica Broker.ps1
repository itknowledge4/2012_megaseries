#Enable the firewall rule for replication on port 80
#Run on all Hyper-V nodes
Enable-NetFirewallRule VIRT-HVRHTTPL-In-TCP-NoScope

#Configure Broker on first cluster
#Run these commands diretly on a cluster node
$Broker="HV02-Broker"
Add-ClusterServerRole -Name $Broker -StaticAddress 192.168.10.22
#Can be run remotely from here
Add-ClusterResource -Name "Virtual Machine Replication Broker" -Type "Virtual Machine Replication Broker" -Group $Broker
Add-ClusterResourceDependency "Virtual Machine Replication Broker" $Broker
Start-ClusterGroup $Broker
Set-VMReplicationServer -ReplicationEnabled $true -AllowedAuthenticationType Kerberos

#Configure broker on second cluster
#Run these commands diretly on a cluster node
$Broker="HV03-Broker"
Add-ClusterServerRole -Name $Broker -StaticAddress 192.168.10.23
#Can be run remotely from here
Add-ClusterResource -Name "Virtual Machine Replication Broker" -Type "Virtual Machine Replication Broker" -Group $Broker
Add-ClusterResourceDependency "Virtual Machine Replication Broker" $Broker
Start-ClusterGroup $Broker
Set-VMReplicationServer -ReplicationEnabled $true -AllowedAuthenticationType Kerberos

#Configure both clusters to accept replication from the other clusters broker
New-VMReplicationAuthorizationEntry -AllowedPrimaryServer 'HV03-Broker.testcorp.com' -ReplicaStorageLocation 'C:\ClusterStorage\Volume1\Replicas' -TrustGroup 'ReplicaGroup'
New-VMReplicationAuthorizationEntry -AllowedPrimaryServer 'HV02-Broker.testcorp.com' -ReplicaStorageLocation 'C:\ClusterStorage\Volume1\Replicas' -TrustGroup 'ReplicaGroup'

#Set up a machine for replication
Enable-VMReplication -VMName 'TestVM' -ReplicaServerName 'HV03-Broker.testcorp.com' -CompressionEnabled $true -RecoveryHistory 2 -ReplicaServerPort 80 -AuthenticationType Kerberos
#Start the initial replication imediately
Start-VMInitialReplication -VMName 'TestVM'
Get-VMReplication -VMName 'TestVM'