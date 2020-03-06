#VM snapshots
Checkpoint-VM -Name 'TestVM1' -SnapshotName 'Snap 1'
Get-VMSnapshot -VMName 'TestVM1'
Checkpoint-VM -Name 'TestVM1' -SnapshotName 'Snap 2'
Restore-VMSnapshot -VMName 'TestVM1' -Name 'Snap 1' -Confirm:$false
Remove-VMSnapshot -VMName 'TestVM1' -Name 'Snap 2'