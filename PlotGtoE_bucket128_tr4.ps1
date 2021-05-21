#Ver_1.1 Emil Romanov  2021.05.07
#set-executionpolicy remotesigned
$iCount = 100
# threads: 1-8
$threads=4
# K: 1-5
$bucket = 128
$Disk = 'G:'
#switch ($threads)
#	{1 		{$ram = 1700}
#	 2 		{$ram = 1694.5}	# 256 корзин - 1700 	
#	 4 		{$ram = 1704} # 128 корзин - 1700
#	 6 		{$ram = 1708} # 64 корзин - 1700
#	 8 		{$ram = 1712} # 32 корзин - 1700	 	
#	 default{$ram = 1700}
#	}
switch ($bucket)
	{256 		{$ram = 1700}	# 256 корзин - 1700 
	 128		{$ram = 3390}	# 128 корзин - 1700 3400	
	 64 		{$ram = 7400}	# 64  корзин - 1700 6800
	 32 		{$ram = 14800}	# 32  корзин - 1700 13600
     16 		{$ram = 29600}	# 32  корзин - 1700 27200
	 default{$ram = 3390}
	}	
	

# Delete all temporary files #Get-ChildItem -Path F:\Temp -Include *.* -File -Recurse | foreach { $_.Delete()}
#cd "C:\Users\romanove\AppData\Local\chia-blockchain\app-1.1.4\resources\app.asar.unpacked\daemon"
cd $env:LOCALAPPDATA
cd .\chia-blockchain\
$appDir = ls "app-*"
cd "$($appDir.Name)\resources\app.asar.unpacked\daemon"
.\chia.exe version
# 256 корзин - 1700, ~128 корзин - ~3400, 64 корзины - ~6800, 32 корзины - ~13600 на плот минимум
# Разработчики пишут, что максимально может использоваться - 6750 MB на один плот, при k=32 со 128 корзинами.
# Start plotting
#3389 is the perfect amount if you are using 2 threads. I have found that 4 threads requires a minimum of 3408; 6 threads 3416; 8 threads 3424.
if (!(test-path "D:\ChiaPS.csv"))
	{"sep=;" > "D:\ChiaPS.csv"	
	 "Date;Time;Plot;Status;R;Buc;Ram;I" >> "D:\ChiaPS.csv"		
	}
for($i=1;$i -le $iCount;$i++)
	{if (!(test-path "D:\chiastop.txt"))
		{$Date = Get-Date
		$WindowTitle = "$Date Plot F to $Disk $i"
		$host.ui.RawUI.WindowTitle = "$WindowTitle"
		$OutStr = "$($Date.ToShortDateString());$($Date.ToShortTimeString());$WindowTitle;Start;$threads;$bucket;$ram;$i"
		$OutStr >> "D:\ChiaPS.csv"
		Write-Host $OutStr -f green
		.\chia.exe plots create -k 32 -n 1 -t "F:\Temp" -d "$Disk\Plot" -b $ram -u $bucket -r $threads
		$Date = Get-Date
		$OutStr = "$($Date.ToShortDateString());$($Date.ToShortTimeString());$WindowTitle;Finish;$threads;$bucket;$ram;$i"
		$OutStr >> "D:\ChiaPS.csv"
		Write-Host $OutStr -f green
		Write-Host "Press CTRL+C for break. Pause 5 minutes" -f green
		Start-Sleep -Seconds 300
		}
    else{
        exit
        }
	}
Read-Host -Prompt "press enter to exit"