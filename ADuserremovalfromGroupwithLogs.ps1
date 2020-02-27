<#
CSV format is....use pipe as delim.....
username|Groupname
temp1|tempgroup1
temp2|tempgroup2
#>

#This script will remove specified user from specified group in csv. Delimiter is "|"

$users = Import-Csv -Path "removeuserfromgroup.csv" -Delimiter "|"
$date = Get-Date -format "dd-MMM-yyyy HH:mm"
foreach($user in $users){

  Write-Output "$date : Removing user $user.username from $user.Groupname" >> output.log
  Remove-ADGroupMember -Identity $user.Groupname -Members $user.username -Confirm:$false -verbose

if($?){
  Write-Output "$date : Successfully removed user $user.username from $user.Groupname" >> output.log
}

}
<#
28-Jan-2020 05:39 : Removing user @{username=temp1; Groupname=tempgroup1}.username from @{username=temp1; Groupname=tempgroup1}.Groupname
28-Jan-2020 05:39 : Successfully removed user @{username=temp1; Groupname=tempgroup1}.username from @{username=temp1; Groupname=tempgroup1}.Groupname
28-Jan-2020 05:39 : Removing user @{username=temp2; Groupname=tempgroup2}.username from @{username=temp2; Groupname=tempgroup2}.Groupname
28-Jan-2020 05:39 : Successfully removed user @{username=temp2; Groupname=tempgroup2}.username from @{username=temp2; Groupname=tempgroup2}.Groupname
28-Jan-2020 05:39 : Removing user @{username=temp1; Groupname=tempgroup1}.username from @{username=temp1; Groupname=tempgroup1}.Groupname
28-Jan-2020 05:39 : Successfully removed user @{username=temp1; Groupname=tempgroup1}.username from @{username=temp1; Groupname=tempgroup1}.Groupname
28-Jan-2020 05:39 : Removing user @{username=temp2; Groupname=tempgroup2}.username from @{username=temp2; Groupname=tempgroup2}.Groupname
28-Jan-2020 05:39 : Successfully removed user @{username=temp2; Groupname=tempgroup2}.username from @{username=temp2; Groupname=tempgroup2}.Groupname
28-Jan-2020 05:44 : Removing user @{username=temp1; Groupname=tempgroup1}.username from @{username=temp1; Groupname=tempgroup1}.Groupname
28-Jan-2020 05:44 : Successfully removed user @{username=temp1; Groupname=tempgroup1}.username from @{username=temp1; Groupname=tempgroup1}.Groupname
28-Jan-2020 05:44 : Removing user @{username=temp2; Groupname=tempgroup2}.username from @{username=temp2; Groupname=tempgroup2}.Groupname
28-Jan-2020 05:44 : Successfully removed user @{username=temp2; Groupname=tempgroup2}.username from @{username=temp2; Groupname=tempgroup2}.Groupname
#>
