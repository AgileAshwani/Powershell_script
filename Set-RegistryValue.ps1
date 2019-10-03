######################################################
# This Script will change RegisteredOwner information.
######################################################

$RegKey ="HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
Set-ItemProperty -Path $RegKey -Name RegisteredOwner -Value TypeHere
