:: sysclean.cmd - universal system clean up script
:: for 32/64-bits OS Windows NT 6.1, 6.2, 6.3, 10.0
:: https://github.com/alexsupra/usetools
@echo off &cls
chcp 866 >nul
net session >nul 2>&1
if %errorLevel% neq 0 echo Administrative permissions check failure!!&echo Restart as administrator&color 0e &pause &exit
for /f "tokens=2*" %%a in ('reg query "hklm\hardware\description\system\centralprocessor\0" /v "ProcessorNameString"') do set "cpuname=%%b"
echo %cpuname% ~ %processor_architecture%
:os_check
for /f "tokens=4-5 delims=. " %%i in ('ver') do set ntver=%%i.%%j
for /f "tokens=4-6 delims=. " %%i in ('ver') do set ntbuild=%%k
set codename=
if "%ntver%"=="4.0" set ntname=Windows NT
if "%ntver%"=="5.0" set ntname=Windows 2000
if "%ntver%"=="5.1" set ntname=Windows XP
if "%ntver%"=="5.2" set ntname=Windows Server 2003
if "%ntver%"=="6.0" set ntname=Windows Vista
if "%ntver%"=="6.1" set ntname=Windows 7
if "%ntver%"=="6.2" set ntname=Windows 8
if "%ntver%"=="6.3" set ntname=Windows 8.1
if "%ntver%"=="10.0" (
	set ntname=Windows 10
	if %ntbuild%==10240 set codename=Threshold
	if %ntbuild%==10586 set codename=Threshold 2
	if %ntbuild%==14393 set codename=Redstone
	if %ntbuild%==15063 set codename=Redstone 2
	if %ntbuild%==16299 set codename=Redstone 3
	if %ntbuild%==17134 set codename=Redstone 4
	if %ntbuild%==17763 set codename=Redstone 5
	if %ntbuild%==18362 set codename=19H1
	if %ntbuild%==18363 set codename=19H2
	if %ntbuild%==19041 set codename=20H1
	if %ntbuild%==19042 set codename=20H2
	if %ntbuild%==19043 set codename=21H1
	if %ntbuild%==19044 set codename=21H2
	if %ntbuild%==19045 set codename=22H2
	if %ntbuild%==22000 (
		set ntname=Windows 11
		set codename=21H2
	)
	if %ntbuild%==22621 (
		set ntname=Windows 11
		set codename=22H2
	)
	if %ntbuild%==22631 (
		set ntname=Windows 11
		set codename=23H2
	)
)
set osarch=x86
wmic OS get OSArchitecture|find.exe "64" >nul
if not errorlevel 1 set osarch=x64
if "%ntver%"=="10.0" (
	if "%osarch%"=="x86" echo [44;97m%ntname% %codename%[0m [;96m NT %ntver%.%ntbuild% [0m [40;93m%osarch%[0m
	if "%osarch%"=="x64" echo [44;97m%ntname% %codename%[0m [;96m NT %ntver%.%ntbuild% [0m [40;92m%osarch%[0m
	) else (
	echo %ntname% %codename% NT %ntver%.%ntbuild% %osarch%
	)
echo %username%@%computername%
::
set sysclean_version=2310.02
echo     ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
echo     ÛÛ    ÛÛ ÛÛßßßßÛÛ ÛßßßßßßÛ ßßßÛÛßßß ÛßßßßßßÛ ÛßßßßßßÛ ÛÛ       ÛÛßßßßÛÛ 
echo     ÛÛ    ÛÛ ÛÛ       Û           ÛÛ    Û      Û Û      Û ÛÛ       ÛÛ       
echo     ÛÛ    ÛÛ  ßßßßßßÛ Ûßßßßß      ÛÛ    Û      Û Û      Û ÛÛ        ßßßßßßÛ  
echo     ÛÛ    ÛÛ ÛÛ     Û Û      Û    ÛÛ    Û      Û Û      Û ÛÛ    ÛÛ ÛÛ     Û 
echo      ßßßßßßß ßßßßßßßß ßßßßßßßß    ßß    ßßßßßßßß ßßßßßßßß ßßßßßßßß ßßßßßßßß  
echo     ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
echo     ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
echo     ³            sysclean.cmd - system clean up script   v%sysclean_version%         ³
echo     ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
echo.
if "%1"=="-c" goto clean
if "%ntver%"=="10.0" ( 
	echo [40;92mPRESS ANY KEY START CLEANING YOUR SYSTEM[0m
	) else (
	echo PRESS ANY KEY START CLEANING YOUR SYSTEM
	)
pause >nul
:clean
echo Cleaning system temporary and cache directories ...&echo.
dir /b %systemroot%\temp >temp.list
for /f "delims=" %%a in (temp.list) do call rundll32.exe advpack.dll,DelNodeRunDLL32 "%systemroot%\temp\%%a"
dir /b %temp% >temp.list
for /f "delims=" %%a in (temp.list) do call rundll32.exe advpack.dll,DelNodeRunDLL32 "%temp%\%%a"
dir /b %tmp% >temp.list
for /f "delims=" %%a in (temp.list) do call rundll32.exe advpack.dll,DelNodeRunDLL32 "%tmp%\%%a"
dir /b %systemroot%\prefetch >temp.list
for /f "delims=" %%a in (temp.list) do call rundll32.exe advpack.dll,DelNodeRunDLL32 "%systemroot%\prefetch\%%a"
dir /b %programdata%\Microsoft\Diagnosis\ETLLogs >temp.list
for /f "delims=" %%a in (temp.list) do call rundll32.exe advpack.dll,DelNodeRunDLL32 "%programdata%\Microsoft\Diagnosis\ETLLogs\%%a"
dir /b "%localappdata%\Microsoft\Windows\Explorer\thumbcache_*.db" >temp.list
for /f "delims=" %%a in (temp.list) do call rundll32.exe advpack.dll,DelNodeRunDLL32 "%localappdata%\Microsoft\Windows\Explorer\%%a"
::
echo Cleaning applications temporary and cache directories ...&echo.
if exist "%localappdata%\Microsoft\Windows\INetCache" (
	attrib -a -r -s -h "%localappdata%\Microsoft\Windows\INetCache\*.*" /s /d
	dir /b "%localappdata%\Microsoft\Windows\INetCache" >temp.list
	for /f "delims=" %%a in (temp.list) do call rundll32.exe advpack.dll,DelNodeRunDLL32 "%localappdata%\Microsoft\Windows\INetCache\%%a"
	)
if "%ntver%"=="6.1" (
	attrib -a -r -s -h "%localappdata%\Microsoft\Windows\Temporary Internet Files\*.*" /s /d
	dir /b "%localappdata%\Microsoft\Windows\Temporary Internet Files" >temp.list
	for /f "delims=" %%a in (temp.list) do call rundll32.exe advpack.dll,DelNodeRunDLL32 "%localappdata%\Microsoft\Windows\Temporary Internet Files\%%a" >nul
	)
if exist "%localappdata%\Google\Chrome\User Data\Default" (
	dir /b "%localappdata%\Google\Chrome\User Data\Default\Cache" >temp.list
	for /f "delims=" %%a in (temp.list) do call rundll32.exe advpack.dll,DelNodeRunDLL32 "%localappdata%\Google\Chrome\User Data\Default\Cache\%%a"
	dir /b "%localappdata%\Google\Chrome\User Data\Default\Code Cache" >temp.list
	for /f "delims=" %%a in (temp.list) do call rundll32.exe advpack.dll,DelNodeRunDLL32 "%localappdata%\Google\Chrome\User Data\Default\Code Cache\%%a"
	)
if exist "%localappdata%\Google\Chrome SxS\User Data\Default" (
	dir /b "%localappdata%\Google\Chrome SxS\User Data\Default\Cache" >temp.list
	for /f "delims=" %%a in (temp.list) do call rundll32.exe advpack.dll,DelNodeRunDLL32 "%localappdata%\Google\Chrome SxS\User Data\Default\Cache\%%a"
	dir /b "%localappdata%\Google\Chrome SxS\User Data\Default\Code Cache" >temp.list
	for /f "delims=" %%a in (temp.list) do call rundll32.exe advpack.dll,DelNodeRunDLL32 "%localappdata%\Google\Chrome SxS\User Data\Default\Code Cache\%%a"
	)
if exist "%localappdata%\Chromium\User Data\Default" (
	dir /b "%localappdata%\Chromium\User Data\Default\Cache" >temp.list
	for /f "delims=" %%a in (temp.list) do call rundll32.exe advpack.dll,DelNodeRunDLL32 "%localappdata%\Chromium\User Data\Default\Cache\%%a"
	dir /b "%localappdata%\Chromium\User Data\Default\Code Cache" >temp.list
	for /f "delims=" %%a in (temp.list) do call rundll32.exe advpack.dll,DelNodeRunDLL32 "%localappdata%\Chromium\User Data\Default\Code Cache\%%a"
	)
if exist "%localappdata%\Vivaldi\User Data\Default" (
	dir /b "%localappdata%\Vivaldi\User Data\Default\Cache" >temp.list
	for /f "delims=" %%a in (temp.list) do call rundll32.exe advpack.dll,DelNodeRunDLL32 "%localappdata%\Vivaldi\User Data\Default\Cache\%%a"
	dir /b "%localappdata%\Vivaldi\User Data\Default\Code Cache" >temp.list
	for /f "delims=" %%a in (temp.list) do call rundll32.exe advpack.dll,DelNodeRunDLL32 "%localappdata%\Vivaldi\User Data\Default\Code Cache\%%a"
	)
if exist "%localappdata%\Yandex\YandexBrowser\User Data\Default" (
	dir /b "%localappdata%\Yandex\YandexBrowser\User Data\Default\Cache" >temp.list
	for /f "delims=" %%a in (temp.list) do call rundll32.exe advpack.dll,DelNodeRunDLL32 "%localappdata%\Yandex\YandexBrowser\User Data\Default\Cache\%%a"
	dir /b "%localappdata%\Yandex\YandexBrowser\User Data\Default\Code Cache" >temp.list
	for /f "delims=" %%a in (temp.list) do call rundll32.exe advpack.dll,DelNodeRunDLL32 "%localappdata%\Yandex\YandexBrowser\User Data\Default\Code Cache\%%a"
	)
if exist "%localappdata%\Opera Software\Opera Stable" (
	dir /b "%localappdata%\Opera Software\Opera Stable\Cache" >temp.list
	for /f "delims=" %%a in (temp.list) do call rundll32.exe advpack.dll,DelNodeRunDLL32 "%localappdata%\Opera Software\Opera Stable\Cache\%%a"
	dir /b "%appdata%\Opera Software\Opera Stable\Code Cache" >temp.list
	for /f "delims=" %%a in (temp.list) do call rundll32.exe advpack.dll,DelNodeRunDLL32 "%appdata%\Opera Software\Opera Stable\Code Cache\%%a"
	)
if exist "%localappdata%\Mozilla\Firefox\Profiles" (
	dir /b "%localappdata%\Mozilla\Firefox\Profiles" >temp.list
	for /f "delims=" %%a in (temp.list) do call rundll32.exe advpack.dll,DelNodeRunDLL32 "%localappdata%\Mozilla\Firefox\Profiles\%%a"
	)
if exist "%localappdata%\Thunderbird\Profiles" (
	dir /b "%localappdata%\Thunderbird\Profiles" >temp.list
	for /f "delims=" %%a in (temp.list) do call rundll32.exe advpack.dll,DelNodeRunDLL32 "%localappdata%\Thunderbird\Profiles\%%a"
	)
del /f /q temp.list >nul
if "%ntver%"=="6.1" goto recycler
echo Cleaning WinSxS directory ...&echo.
dism.exe /online /Cleanup-Image /StartComponentCleanup
:recycler
echo Cleaning Recycle.Bin ...&echo.
for %%p in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do if exist "%%p:\$Recycle.Bin" rundll32.exe advpack.dll,DelNodeRunDLL32 "%%p:\$Recycle.Bin"
if "%ntver%"=="10.0" ( 
	echo [42;97mREADY. PRESS ANY KEY TO EXIT[0m
	) else (
	echo READY. PRESS ANY KEY TO EXIT
	)
pause >nul
::