#Resource metering
Enable-VMResourceMetering -VMName 'TestVM3'
Measure-VM -Name 'TestVM3'
Reset-VMResourceMetering -VMName 'TestVM3'
Disable-VMResourceMetering -VMName 'TestVM3'