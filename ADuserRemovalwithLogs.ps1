#This script will remove specified user from AD with logs

$users = Get-Content ".\users27.txt"
$date = Get-Date -format "dd-MMM-yyyy HH:mm"
foreach($user in $users){

  Get-ADUser -Identity $user -Verbose
if($?){
  Write-Output "$date : Removing user $user from Active Directory" >> output.log
}
else{
  Write-Output "$date : AD User $user not found in Active Directory" >> output.log
}
   
  Remove-ADUser -Identity $user -Confirm:$false -Verbose
if($?){
  Write-Output "$date : Successfully removed user $user Active Directory" >> output.log
}

}
<#
26-Feb-2020 22:40 : Removing user temp3 from Active Directory
26-Feb-2020 22:40 : Successfully removed user temp3 Active Directory
26-Feb-2020 22:40 : AD User temp1 not found in Active Directory
26-Feb-2020 22:40 : Removing user temp4 from Active Directory
26-Feb-2020 22:40 : Successfully removed user temp4 Active Directory
26-Feb-2020 22:40 : AD User temp2 not found in Active Directory
#>
