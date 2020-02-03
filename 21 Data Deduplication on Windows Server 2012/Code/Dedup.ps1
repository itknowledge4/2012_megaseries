#Install dedup
Install-WindowsFeature FS-Data-Deduplication

#Get list of commands
Get-Command -Module Deduplication

#Evaluate saving for a volume
ddpeval F:

#Enable deduplication
Enable-DedupVolume G:

#Deduplicate files no matter how old they are
Set-DedupVolume -Volume G: -MinimumFileAgeDays 0

#Start a dedup job
Start-DedupJob -Type Optimization -Volume G:

#Get status of deduplication
Get-DedupStatus