#Description: Create a table showing the drive utilisation in percentage, drive letter. Output into a csv file.
#Author: Ashwani k
#Version History: 1.0
#Date: 30/April/2018

# ----------------DECLARE GLOBAL VARIABLES AND CONSONANTS-----------------------

$SCRIPT_DIR = split-path -parent $MyInvocation.MyCommand.Definition
$LOG_DIR = $SCRIPT_DIR
#$LOG_DIR = "$env:systemdrive\temp\PsLogs"
$LOG_FILENAME = "Log$(Get-Date -Format yyyyMMdd).log"
$LOG_FILE = "$LOG_DIR\$Log_filename"
$TIMESTAMP = "[$(Get-Date -Format yyyy-MM-dd$([char]32)HH:mm:ss)]"

# ----------------FUNCTIONS LIBRARY-----------------------------------

function Write-Log {
  param(
        [string]$msg, 
        [string]$type="LOG"
       )
  Out-File -FilePath $LOG_FILE -InputObject "$Timestamp [$type] $msg"  -Append 
}

function MathRound([int]$num, [int]$decplaces){
  return [system.math]::Round($num, $decplaces)

}


# ----------------MAIN SCRIPT-----------------------------------

#$DriveList = Get-WmiObject -Class Win32_LogicalDisk | Where-Object{$_.DriveType -eq "3" }

$Disks = Get-WmiObject -Class Win32_LogicalDisk #| Where-Object{$_.DriveType -eq "3"}

$Disks | Format-Table  | Export-Csv C:\temp\DiskInfo.csv -NoTypeInformation 

$outputobj = @()

foreach($Disk in $Disks){

   [system.windows.forms.messagebox]::Show("Loop interation ")
   
   $DiskName = $Disk.DeviceID  #| Format-Table *| Export-Csv -Path "$SCRIPT_DIR\diskutil.csv" -NoTypeInformation
   
   
   
   if(-not ($Disk.FreeSpace -eq $null)){
     [int]$UtilPercent = ($Disk.FreeSpace/$Disk.Size)*100
     $DiskUtilization = MathRound -num $UtilPercent -decplaces 2  #| Format-Table *| Export-Csv -Path "$SCRIPT_DIR\diskutil.csv" -NoTypeInformation
   }
   else{
     $DiskUtilization = "0"
   }  
   
   $tempobj = "" | select DeviceID, DiskUtilization 
   Write-Host $tempobj
   [system.windows.forms.messagebox]::Show("TempObh Just created ")
   $tempobj.DeviceID = $DiskName
   $tempobj.DiskUtilization = $DiskUtilization
   Write-Host $tempobj
   
   [system.windows.forms.messagebox]::Show("click to move ahead ")
   
   $outputobj += $tempobj
       
}

Write-Host $outputobj

[system.windows.forms.messagebox]::Show("Loop ended. export ops not started")

$outputobj | Export-Csv C:\temp\DiskInfo.csv -NoTypeInformation







# ----------------OUTPUT STARTS HERE---------------------------------------------


