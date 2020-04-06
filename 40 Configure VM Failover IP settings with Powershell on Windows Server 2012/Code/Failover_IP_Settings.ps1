#Run this on primary server
Set-VMNetworkAdapterFailoverConfiguration 'TestVM' -IPv4Address 192.168.11.8 -IPv4SubnetMask 255.255.255.0 -IPv4DefaultGateway 192.168.11.254

#To change also the switch to which the machine will connect on the replica server
#Run on the replica server
Set-VMNetworkAdapter 'TestVM' -TestReplicaSwitchName 'TestSW'