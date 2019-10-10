# where do you want to create the local admin account?
$ComputerName = $env:COMPUTERNAME
# what is the name of the local admin group?
# WARNING: MUST EXIST! MAY BE DIFFERENT IN DIFFERENT LOCALES
$Group = 'Administrators'
# what is the name of the new account?
$Name = 'ServiceAdmin'
# what is the password?
$Password = 'topSecret123'
# what is the description?
$Description = 'Automatically generated local account'

$computer = [ADSI]"WinNT://$($ComputerName),computer"
$user = $computer.Create('User', "$($Name)")
$user.SetPassword($password)
$user.Put('Description',$($Description))    
$user.SetInfo()

# password never expires
$user.UserFlags.value = $user.UserFlags.value -bor 0x10000
$user.CommitChanges()

# add user to group
$group = [ADSI]"WinNT://$($Computername)/$($group),group" 
$group.add("WinNT://$($Computername)/$($Name),user")
