$computer=Get-ADComputer hv01
Set-ADObject -Identity $Computer -Add @{'msDS-AllowedToDelegateTo' = ('cifs/HV02.testcorp.local')}
Set-ADObject -Identity $Computer -Add @{'msDS-AllowedToDelegateTo' = ('Microsoft Virtual System Migration Service/HV02')}
Set-ADAccountControl -Identity $Computer -TrustedForDelegation $true

$computer=Get-ADComputer hv02
Set-ADObject -Identity $Computer -Add @{'msDS-AllowedToDelegateTo' = ('cifs/HV01.testcorp.local')}
Set-ADObject -Identity $Computer -Add @{'msDS-AllowedToDelegateTo' = ('Microsoft Virtual System Migration Service/HV01')}
Set-ADAccountControl -Identity $Computer -TrustedForDelegation $true