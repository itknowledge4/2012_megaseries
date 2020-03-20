#Settings for replication have to be enabled on hosts that will take part in the replication scenario
#Configure Hyper-V replica
Set-VMReplicationServer -ReplicationEnabled $true -AllowedAuthenticationType Kerberos -DefaultStorageLocation 'C:\Replicas' -ReplicationAllowedFromAnyServer $true

#Set a server for trusted replication. Works only if -ReplicationAllowedFromAnyServer is $false
New-VMReplicationAuthorizationEntry -AllowedPrimaryServer 'HVS01.testcorp.com' -ReplicaStorageLocation 'C:\ReplicaHV02' -TrustGroup 'ReplicaGroup'
Remove-VMReplicationAuthorizationEntry -AllowedPrimaryServer 'HVS01.testcorp.com'

#Enable the firewall rule for replication on port 80
Enable-NetFirewallRule VIRT-HVRHTTPL-In-TCP-NoScope

#Enable replication for a VM with 3 stored replicas and no VSS
Enable-VMReplication -VMName 'TestVM1' -ReplicaServerName 'HVS01.testcorp.com' -CompressionEnabled $true -RecoveryHistory 3 -ReplicaServerPort 80 -AuthenticationType Kerberos
#Start the initial replication imediately
Start-VMInitialReplication -VMName 'TestVM1'
Get-VMReplication -VMName 'TestVM1'
Measure-VMReplication -VMName 'TestVM1'
Suspend-VMReplication -VMName 'TestVM1'
Resume-VMReplication -VMName 'TestVM1'
#Failover a VM to the replica server and convert the replica VM to a primary one and reverse the replication (planned failover)
Start-VMFailover -VMName 'TestVM1' -Prepare -Confirm:$false #Run on primary host
Start-VMFailover -VMName 'TestVM1' -Confirm:$false #Run on replica host
Set-VMReplication -Reverse -VMName 'TestVM1' #Run on replica host
#The VM that is now the replica will not be moved to the replica path but remain where it is

#Unplanned failover (the vm on HVS01 is down, the replica on HV01 should come up but we use the second to last snapshot because the last one is corrupted)
$snaps=Get-VMSnapshot -VMName 'TestVM1' -SnapshotType Replica
Start-VMFailover -VMRecoverySnapshot $snaps[1] -Confirm:$false
Complete-VMFailover -VMName 'TestVM1' -Confirm:$false
Set-VMReplication -VMName 'TestVM1' -AsReplica #Run on new replica host
Set-VMReplication -Reverse -VMName 'TestVM1'
Start-VMInitialReplication -VMName 'TestVM1'