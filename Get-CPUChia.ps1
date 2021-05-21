#get-ciminstance win32_perfformatteddata_perfproc_process|sort -d percentprocessortime|ft name,percentprocessortime
cls

while(1){
    $cpu = 0
    $process = get-ciminstance win32_perfformatteddata_perfproc_process
    foreach($proces in $process)
        {if($($proces.name) -like "chia#*")
            {$cpu += $($proces.percentprocessortime)
            #Write-Host "$($proces.percentprocessortime) " -NoNewline
            }        
        }
    Write-Host $cpu -f Green
    sleep 3
}