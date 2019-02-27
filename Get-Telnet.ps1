Function Get-Telnet
{   Param (
        [Parameter(ValueFromPipeline=$true)]
        [String[]]$Commands = @("username","password","disable clipaging","sh config"),
        [string]$RemoteHost = "HostnameOrIPAddress",
        [string]$Port = "23",
        [int]$WaitTime = 1000,
        [string]$OutputPath = "\\server\share\switchbackup.txt"
    )


    #Attach to the remote device, setup streaming requirements
    $Socket = New-Object System.Net.Sockets.TcpClient($RemoteHost, $Port)
    If ($Socket)
    {   $Stream = $Socket.GetStream()
        $Writer = New-Object System.IO.StreamWriter($Stream)
        $Buffer = New-Object System.Byte[] 1024 
        $Encoding = New-Object System.Text.AsciiEncoding

        #Now start issuing the commands
        ForEach ($Command in $Commands)
        {   Start-Sleep -Milliseconds $WaitTime
            $Writer.WriteLine($Command) 
            $Writer.Flush()
            Start-Sleep -Milliseconds $WaitTime
        }
        #All commands issued, but since the last command is usually going to be
        #the longest let's wait a little longer for it to finish
        Start-Sleep -Milliseconds ($WaitTime * 4)
        $Result = ""
        #Save all the results
        While($Stream.DataAvailable) 
        {   $Read = $Stream.Read($Buffer, 0, 1024)
            $Result += ($Encoding.GetString($Buffer, 0, $Read))
        }
    }
    Else     
    {   $Result = "Unable to connect to host: $($RemoteHost):$Port"
    }
    #Done, now save the results to a file
    $Result | Out-File $OutputPath -Append
    
}

$telTargets = Get-Content -Path "C:\scripts\servers.txt"

foreach($telTarget in $telTargets){
    
    Get-Telnet -RemoteHost $telTarget -Commands "username","password","dhcpinfo eth0","storage -list devices" -OutputPath "C:\scripts\output.txt" -WaitTime 2000

                                  }

