
 function UserExport ($usrname){
                    
                        $user = get-aduser $usrname -properties samaccountname,givenname,surname
                        $groups = Get-ADPrincipalGroupMembership $usrname | select -expand name
                        $data = [PSCustomObject]@{
                                  samaccountname = $user.samaccountname;
                                  givenname = $user.givenname;
                                  surname = $user.surname;
                                  memberOf = ($groups -join ',' )
                                }
                        $data  | Export-Csv .\UserInfo.csv -Delimiter ";" -NoTypeInformation -Encoding UTF8 -Append
                     }

$adusers = Get-ADUser -Filter * -SearchBase "OU=Tesco,DC=CORPTEST,DC=AD" | Select-Object samaccountname

foreach($aduser in $adusers){

    UserExport -usrname $aduser.samaccountname
    
}