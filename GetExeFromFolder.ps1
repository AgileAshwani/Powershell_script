#Description: Create a list of all exe files in c:\windows\system32
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


# ----------------MAIN SCRIPT-----------------------------------

if(-not (Test-Path $LOG_DIR)){New-Item -Path $LOG_DIR -ItemType directory -Force}
if(-not (Test-Path $LOG_FILE)){New-Item -ItemType file -Path $LOG_FILE}

$TargetFolder = "$($env:windir)\system32"
$server_name = $server_name.tolower()

$TargetFiles = Get-ChildItem $TargetFolder

foreach($File in $TargetFiles){

 if($File.Extension -eq ".exe"){
    
    write-log -msg $File.FullName -type "DATA"
 
 }

}



# ----------------OUTPUT STARTS HERE---------------------------------------------




