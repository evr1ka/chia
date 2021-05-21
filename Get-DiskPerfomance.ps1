cls
$DiskFilter = "name= 'F:' "
$Sleep=3
$Idle1=$DiskTime1=$T1=$Idle2=$DiskTime2=$T2=1
$DateStr = Get-Date -Format "yyyy.MM.dd HH.mm"
$LogFile = "C:\Temp\$DateStr SystemCounters.csv"
if (!(test-path $LogFile))
	{"sep=;" > $LogFile	
	# "Date;Time;PercentIdleTime;PercentDiskTime" >> $LogFile	
    #"DateTime;PercentDiskReadTime;PercentDiskWriteTime;PercentRamTime"
    	
    "DateTime;PercentDiskReadTime;PercentDiskWriteTime;RamAvailable;PercentIdleTime;PercentDiskTime;RamDeviation;RamAvaiableMb2;RamAvaiableMb1" >> $LogFile		
	}
$FullRam = 32*1024

function AddSpace($In)
    {$out = $In
    if     ((0 -le $In) -and ($In -le 9))          {$out = "     $In"}
    elseif ((10 -le $In) -and ($In -le 99))        {$out = "    $In"}
    elseif ((100 -le $In) -and ($In -le 999))      {$out = "   $In"}
    elseif ((1000 -le $In) -and ($In -le 9999))    {$out = "  $In"}
    elseif ((10000 -le $In) -and ($In -le 99999))  {$out = " $In"}
    elseif ((100000 -le $In) -and ($In -le 999999)){$out = "$In"}
    else {$out = "     $In"}
    return $out
    }

For($i=0;$i -le 100; $i=0)
    {$Date = Get-Date
    $Disk = Get-WmiObject -class Win32_PerfRawData_PerfDisk_LogicalDisk -filter $DiskFilter
	$RamAvaiableMb1 = $(Get-Counter -Counter "\Память\Доступно МБ").CounterSamples.CookedValue
    [Double]$Idle1 = $Disk.PercentIdleTime
    [Double]$DiskTime1 = $Disk.PercentDiskTime
    [Double]$DiskReadTime1 = $Disk.PercentDiskReadTime
    [Double]$DiskWriteTime1 = $Disk.PercentDiskWriteTime
	
    [Double]$T1 = $Disk.TimeStamp_Sys100NS

    start-Sleep $Sleep

    $Disk = Get-WmiObject -class Win32_PerfRawData_PerfDisk_LogicalDisk -filter $DiskFilter
	$RamAvaiableMb2 = $(Get-Counter -Counter "\Память\Доступно МБ").CounterSamples.CookedValue
    [Double]$Idle2 = $Disk.PercentIdleTime
    [Double]$DiskTime2 = $Disk.PercentDiskTime
    [Double]$DiskReadTime2 = $Disk.PercentDiskReadTime
    [Double]$DiskWriteTime2 = $Disk.PercentDiskWriteTime

    [Double]$T2 = $Disk.TimeStamp_Sys100NS

    $PercentIdleTime =[math]::Round((($Idle2 - $Idle1) / ($T2 - $T1)) * 100)
    $PercentDiskTime =[math]::Round((($DiskTime2 - $DiskTime1) / ($T2 - $T1)) * 100)

    $PercentDiskReadTime =[math]::Round((($DiskReadTime2 - $DiskReadTime1) / ($T2 - $T1)) * 100)
    $PercentDiskWriteTime =[math]::Round((($DiskWriteTime2 - $DiskWriteTime1) / ($T2 - $T1)) * 100)

	$RamDeviation = (($RamAvaiableMb2 - $RamAvaiableMb1))
    #$PercentRamTime = [math]::Round((($FullRam-$RamAvaiableMb2)/$FullRam) * 100)
    $RamAvailableGB = (($RamAvaiableMb2)/1024)

    $Date = Get-Date
    Write-host "$Date" -f White -NoNewline
    #Write-host " $PercentIdleTime" -f Red -NoNewline
	#Write-host " $PercentDiskTime" -f DarkRed  -NoNewline    
    Write-host " $(AddSpace($PercentDiskReadTime))" -f Green  -NoNewline
    Write-host " $(AddSpace($PercentDiskWriteTime))" -f Yellow  -NoNewline
    Write-host " $(AddSpace($PercentIdleTime)) " -f Red  -NoNewline
    '{0:N2}' -f  $RamAvailableGb
    #Write-host " $RamAvaiableMb2" -f Blue  -NoNewline 
    #If ($RamDeviation -lt 0)
    #    {Write-host " $RamDeviation" -f DarkRed
    #    }
    #else{
    #    Write-host " $RamDeviation" -f Red   
	#    }
    #"$($Date.ToShortDateString());$($Date.ToShortTimeString());$PercentIdleTime;$PercentDiskTime;$PercentRamTime;$RamAvaiableMb2;$RamAvaiableMb1" >> $LogFile
    #"$Date;$PercentIdleTime;$PercentDiskTime;$PercentDiskReadTime;$PercentDiskWriteTime;$RamDeviation;$PercentRamTime;$RamAvaiableMb2;$RamAvaiableMb1" >> $LogFile
    "$Date;$PercentDiskReadTime;$PercentDiskWriteTime;$RamAvailable;$PercentIdleTime;$PercentDiskTime;$RamDeviation;$RamAvaiableMb2;$RamAvaiableMb1" >> $LogFile		
}