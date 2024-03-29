Clear-Host
#Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force #сделать один раз при первом запуске скрипта, если раньше скрипты не запускались.
Remove-Variable -Name * -Force -ErrorAction SilentlyContinue


$filename = "counters" + " " + (Get-Date).tostring("dd-MM-yyyy-hh-mm-ss")  
$filelocation = New-Item -type file -Path "c:\$filename.txt"
$totalRam = (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).Sum 		 #получаем общее количество оперативной памяти в байтах

while($true) {
    $date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $cpuLoad = (Get-Counter  '\процессор(_Total)\% загруженности процессора').CounterSamples.CookedValue #получаем счётчик загрузки процессора
    $availMem = (Get-Counter '\память\доступно МБ').CounterSamples.CookedValue 							 #получаем счётчик доступной оперативной памяти
	$freeDisk = (Get-Counter '\Логический диск(C:)\Свободно мегабайт').CounterSamples.CookedValue/1024	 #получаем счётчик свободного места на диске С
	$date + ' > CPU load: ' + $cpuLoad.ToString("#,0.000") + '%, Available memory: ' + $availMem.ToString("N0") + ' MB (' + (104857600 * $availMem / $totalRam).ToString("#,0.0") + '%)' + ', Free disk C: ' + $freeDisk.ToString("#,0") + ' Gb' | Out-File $filelocation -Append
    Start-Sleep -s 60
}