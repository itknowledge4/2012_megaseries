### Server tasks
#Sign a zone with default settings
Invoke-DnsServerZoneSign -ZoneName sec.local -SignWithDefault -Force

#Sign a zone and specify settings
Reset-DnsServerZoneKeyMasterRole -ZoneName sec.local -KeyMasterServer dc02.testcorp.local -SeizeRole -Force
Set-DnsServerDnsSecZoneSetting -ZoneName sec.local -DenialOfExistence NSec
Add-DnsServerSigningKey -ZoneName sec.local -Type KeySigningKey -CryptoAlgorithm RsaSha1NSec3 –KeyLength 3072
Add-DnsServerSigningKey -ZoneName sec.local -Type ZoneSigningKey -CryptoAlgorithm RsaSha1NSec3 –KeyLength 2048
Invoke-DnsServerZoneSign -ZoneName sec.local -Force

#Unsign a zone
Invoke-DnsServerZoneUnSign -ZoneName sec.local -Force

#Test a DNSSEC enabled zone; error code should be 0
Test-DnsServerDnsSecZoneSetting -ZoneName sec.local
#Get a list of trust points
Get-DnsServerTrustPoint
#Get a list of trust anchors
Get-DnsServerTrustAnchor -Name sec.local
#See info about a zone's DNSSEC settings
Get-DnsServerDnsSecZoneSetting -ZoneName secure.contoso.com
#Get info about a zone's keys
Get-DnsServerSigningKey -ZoneName sec.local

#Move the Ket Master role to another server
Reset-DnsServerZoneKeyMasterRole -ZoneName sec.local -KeyMasterServer DC03.testcorp.local -force


### Client tasks
#Try to resolve a DNS entry and use DNSSEC validation
Resolve-DnsName t2.sec.local -DnssecOk -Server dc03.testcorp.local

#Get a list of NRTP policies that take effect on the client; if nothing is returned than the client is not forced to use DNSSEC validation for any zone
Get-DnsClientNrptPolicy -Effective