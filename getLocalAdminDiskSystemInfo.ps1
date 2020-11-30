# ----------------FUNCTIONS LIBRARY-----------------------------------

function GetMachineType {
    $ComputerSystemInfo = Get-WmiObject -Class Win32_ComputerSystem
    switch -Regex ($ComputerSystemInfo.Model) { 

        # Check for VMware Machine Type 
        "VMware" { 
            Write-Output "VMware Virtual Machine"
            Break 
        } 

        # Check for Oracle VM Machine Type 
        "VirtualBox" { 
            Write-Output "Oracle Virtual Machine"
            Break 
        } 
        default { 

            switch ($ComputerSystemInfo.Manufacturer) {

                # Check for Xen VM Machine Type
                "Xen" {
                    Write-Output "Xen Virtual Machine"
                    Break
                }

                # Check for KVM VM Machine Type
                "QEMU" {
                    Write-Output "QEMU Virtual Machine"
                    Break
                }
                # Check for Hyper-V Machine Type 
                "Microsoft Corporation" { 
                    if (get-service WindowsAzureGuestAgent -ErrorAction SilentlyContinue) {
                        Write-Output "Microsoft Azure Virtual Machine"
                    }
                    else {
                        Write-Output "Microsoft Hyper-V Virtual Machine"
                    }
                    Break
                }
                # Check for Google Cloud Platform
                "Google" {
                    Write-Output "Google Cloud Virtual Machine"
                    Break
                }

                # Check for AWS Cloud Platform
                default { 
                    if ((((Get-WmiObject -query "select uuid from Win32_ComputerSystemProduct" | Select-Object UUID).UUID).substring(0, 3) ) -match "EC2") {
                        Write-Output "AWS Virtual Machine"
                    }
                    # Otherwise it is a physical Box 
                    else {
                        Write-Output "Physical Machine"
                    }
                } 
            }                  
        } 
    } 

}

function GetMachineHWType{

  $MachinePCSystemType = Get-WmiObject -Class Win32_ComputerSystem
  
    if ($MachinePCSystemType.PCSystemType -eq 2){
        
        Write-Output "Laptop"
    }
    
    else {
        
        Write-Output "Desktop"
    }

}

function Get-TimeStamp {
    
    return "[{0:MM/dd/yyyy} {0:HH:mm:ss}]" -f (Get-Date)
    
}


function MathRound([int]$num, [int]$decplaces){
  return [system.math]::Round($num, $decplaces)

}


# ----------------MAIN SCRIPT------------------------------------------------------

#-----------------Fetching Local Administrators group information-------------------------

Get-LocalGroupMember -Name "Administrators" | Out-File "AdminMembers.txt"

#-----------------Fetching Event Logs-----------------------------------------------------

$LogTypes = 'System','Security','Application'

foreach($LogType in $LogTypes){

Get-EventLog -LogName $LogType -After (Get-Date).AddDays(-15) | Format-List | Out-File ($LogType + "_Log.txt")

}


$Disks = Get-WmiObject -Class Win32_LogicalDisk

$outputobj = @()

foreach($Disk in $Disks){

   
   $DiskName = $Disk.DeviceID
  
   
   if(-not ($Disk.FreeSpace -eq $null)){
     [int]$UtilPercent = ($Disk.FreeSpace/$Disk.Size)*100
     $DiskUtilization = MathRound -num $UtilPercent -decplaces 2
   }
   else{
     $DiskUtilization = "0"
   }  
   
   $tempobj = "" | select DeviceID, DiskFreePercent, TotalSizeGB, FreeSpaceGB, DriveType
   $tempobj.TotalSizeGB = $Disk.Size/1GB
   $tempobj.DeviceID = $DiskName
   $tempobj.FreeSpaceGB = ($Disk.FreeSpace)/1GB
   $tempobj.DiskFreePercent = $DiskUtilization
   $tempobj.DriveType = $Disk.DriveType
   
   $outputobj += $tempobj
       
}

$outputobj | Export-Csv DiskInfo.csv -NoTypeInformation

#------------------------------------System Information Connection Started---------------------------------------------------

[string]$MachineFQDN    = (Get-WmiObject win32_computersystem).DNSHostName+"."+(Get-WmiObject win32_computersystem).Domain
[string]$MachineType    = (GetMachineType)
[string]$MachineHWType  = (GetMachineHWType)
[string]$MachineModel   = (Get-WmiObject -Class win32_computersystem).model
[int32]$MachineTotalRAM = ((Get-WmiObject -Class win32_computersystem).TotalPhysicalMemory/1GB)
[string]$MachineBiosVersion = (Get-WmiObject -Class win32_BIOS).SMBIOSBIOSVersion
[string]$MachineBiosManufacturer = (Get-WmiObject -Class win32_BIOS).Manufacturer
[string]$MachineSerialNumber = (Get-WmiObject -Class win32_BIOS).SerialNumber
        
        $MachineNetworks = Get-WmiObject Win32_NetworkAdapterConfiguration -EA Stop | ? {$_.IPEnabled}

        [string]$MACAddress  = $MachineNetworks.MacAddress
        [string]$DHCPStatus = $MachineNetworks.dhcpenabled
        [string]$IPAddress  = $MachineNetworks.IpAddress
        [string]$SubnetMask  = $MachineNetworks.IPSubnet
        [string]$DefaultIPGateway  = $MachineNetworks.DefaultIPGateway

        [string]$IPAddressOut  = "IP=$IPAddress;SM=$SubnetMask;DG=$DefaultIPGateway;MAC=$MACAddress;DH=$DHCPStatus"

[string]$MachineOStype = ((Get-WMIObject win32_operatingsystem).caption) +" "+ ((Get-WMIObject win32_operatingsystem).OSArchitecture)
[string]$MachineOSServicePack = (Get-WMIObject win32_operatingsystem).servicepackmajorversion
[string]$MachineOSversion = ((Get-WMIObject win32_operatingsystem).version)
[string]$MachineOSbuildnumber = ((Get-WMIObject win32_operatingsystem).buildnumber)
        $MachineTimeStamp = (Get-TimeStamp)

        

# ----------------OUTPUT STARTS HERE---------------------------------------------

$reportobj = "" | select MachineFQDN, MachineType, MachineModel, MachineTotalRAM, MachineBiosVersion, MachineBiosManufacturer, MachineSerialNumber, IPAddress, ` 
                         MachineOSType, MachineServicePAck, MachineOSversion, MachineOSbuildnumber, MachineTimeStamp

$reportobj.MachineFQDN = $MachineFQDN
$reportobj.MachineType = $MachineType
$reportobj.MachineModel = $MachineModel
$reportobj.MachineTotalRAM = $MachineTotalRAM
$reportobj.MachineBiosVersion = $MachineBiosVersion
$reportobj.MachineBiosManufacturer = $MachineBiosManufacturer
$reportobj.MachineSerialNumber = $MachineSerialNumber
$reportobj.IPAddress = $IPAddressout
$reportobj.MachineOSType = $MachineOSType
$reportobj.MachineServicePack = $MachineOSServicePack
$reportobj.MachineOSversion = $MachineOSversion
$reportobj.MachineOSbuildnumber = $MachineOSbuildnumber
$reportobj.MachineTimeStamp = $MachineTimeStamp

$reportobj | Export-Csv "MachineReport.csv" -NoTypeInformation

# ----------------OUTPUT ENDS HERE---------------------------------------------#
