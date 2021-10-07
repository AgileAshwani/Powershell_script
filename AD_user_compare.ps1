$userlist = "User_1","User_2"

$users = 
foreach($user in $userlist) { get-qaduser -identity $user -includeallproperties | Select *}

$userprops = $users[0].psobject.properties.name

$(foreach ($userprop in $userprops)
 {
   foreach ($user in $users)
    { 
     $ObjProps =  @{
      Attribute = $userprop
      User1 = $Users[0].$userprop
      User2 = $Users[1].$userprop
    }
    New-Object PSObject -Property $ObjProps |
     Select Attribute,User1,User2
   } 
  }) | Out-Gridview
