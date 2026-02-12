:: backupaccount.cmd - quickly create backup of user data
:: for 32/64-bits OS Windows NT 6.1, 6.2, 6.3, 10.0
:: https://github.com/alexsupra/usetools
@echo off
set backupaccount_version=2602.01
chcp 866 >nul
if "%1"=="-s" goto os_check
net session >nul 2>&1
if %errorLevel% neq 0 title %~nx0&echo Administrative permissions check failure!!&echo RESTART AS ADMINISTRATOR&color 0e &pause &exit
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
	if %ntbuild%==26052 (
		set ntname=Windows 11
		set codename=24H2
	)
	if %ntbuild%==26100 (
		set ntname=Windows 11
		set codename=24H2
	)
	if %ntbuild%==26200 (
		set ntname=Windows 11
		set codename=25H2
	)
)
set osarch=x86
echo %processor_architecture%|find.exe "64" >nul
if not errorlevel 1 set osarch=x64
for /f "tokens=2*" %%a in ('reg query "hklm\system\controlset001\control\nls\language" /v "Installlanguage"') do set "systemlang=%%b"
if "%ntver%"=="10.0" (
	if "%osarch%"=="x86" echo [44;97m%ntname% %codename%[0m [;96m NT %ntver%.%ntbuild% [0m [40;93m%osarch%[0m
	if "%osarch%"=="x64" echo [44;97m%ntname% %codename%[0m [;96m NT %ntver%.%ntbuild% [0m [40;92m%osarch%[0m
	) else (
	echo %ntname% %codename% NT %ntver%.%ntbuild% %osarch%
	)
title %~nx0&echo %username%@%computername%
::
echo     ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
echo     ÛÛ    ÛÛ ÛÛßßßßÛÛ ÛßßßßßßÛ ßßßÛÛßßß ÛßßßßßßÛ ÛßßßßßßÛ ÛÛ       ÛÛßßßßÛÛ 
echo     ÛÛ    ÛÛ ÛÛ       Û           ÛÛ    Û      Û Û      Û ÛÛ       ÛÛ       
echo     ÛÛ    ÛÛ  ßßßßßßÛ Ûßßßßß      ÛÛ    Û      Û Û      Û ÛÛ        ßßßßßßÛ  
echo     ÛÛ    ÛÛ ÛÛ     Û Û      Û    ÛÛ    Û      Û Û      Û ÛÛ    ÛÛ ÛÛ     Û 
echo      ßßßßßßß ßßßßßßßß ßßßßßßßß    ßß    ßßßßßßßß ßßßßßßßß ßßßßßßßß ßßßßßßßß  
echo     ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
echo     ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
echo     ³  backupaccount.cmd - quickly create backup of user data  v%backupaccount_version%   ³
echo     ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
echo. &echo 	-b create web browsers profiles backup only
echo. &echo 	-f create full backup including web browsers profiles
cd /d "%~dp0"
set sysinstall=%cd%
set setupbin=%cd%\setupbin
set path=%path%;%sysinstall%;%setupbin%
::
if not exist "%userprofile%\backup" md "%userprofile%\backup"
set backupdir=%userprofile%\backup
echo. & echo	backup dir: %backupdir%
::
:check
if not exist "%sysinstall%\7za.exe" goto get7z
if "%1"=="-b" goto browsers
if "%1"=="-f" goto startbackup
if "%ntver%"=="10.0" echo [50;92mPRESS ANY KEY TO START BACKUP[0m
if "%ntver%" neq "10.0" echo PRESS ANY KEY TO START BACKUP
pause >nul
::
:startbackup
echo Creating current user %userprofile%\desktop archive ... &echo.
7za.exe a "%backupdir%\desktop_%date%.7z" "%userprofile%\desktop" -o"%backupdir%\" -mx=4
echo Creating current user %userprofile%\documents archive ... &echo.
7za.exe a "%backupdir%\documents_%date%.7z" "%userprofile%\documents" -o"%backupdir%\" -mx=4
if "%1"=="-f" goto full
goto completed
::
:full
echo Creating current user downloads folder archive ... &echo.
7za.exe a "%backupdir%\downloads_%date%.7z" "%userprofile%\downloads" -o"%backupdir%\" -mx=4
echo Creating current user pictures folder archive ... &echo.
7za.exe a "%backupdir%\pictures_%date%.7z" "%userprofile%\pictures" -o"%backupdir%\" -mx=4
echo Creating current user videos folder archive ... &echo.
7za.exe a "%backupdir%\videos_%date%.7z" "%userprofile%\videos" -o"%backupdir%\" -mx=4
::
:browsers
echo Creating current user web browsers profiles archives ... &echo.
tasklist /fi "imagename eq chrome.exe" |find ":" >nul
if errorlevel 1 taskkill /f /im "chrome.exe"
if exist "%localappdata%\Google\Chrome\User Data\Default\" (
	echo Creating Google Chrome profile backup ..." &echo.
	7za.exe a "%backupdir%\chrome_%date%.7z" "%localappdata%\Google\Chrome\User Data\Default\" -o"%backupdir%\" -mx=4
	)
tasklist /fi "imagename eq chrome.exe" |find ":" >nul
if errorlevel 1 taskkill /f /im "chrome.exe"
if exist "%localappdata%\Google\Chrome SxS\User Data\" (
	echo Creating Google Chrome Canary profile backup ... &echo.
	7za.exe a "%backupdir%\chromecanary_%date%.7z" "%localappdata%\Google\Chrome SxS\User Data\" -o"%backupdir%\" -mx=4
	)
tasklist /fi "imagename eq chrome.exe" |find ":" >nul
if errorlevel 1 taskkill /f /im "chrome.exe"
if exist "%localappdata%\Chromium\User Data\Default\" (
	echo Creating Chromium profile backup ... &echo.
	7za.exe a "%backupdir%\chromium_%date%.7z" "%localappdata%\Chromium\User Data\Default\" -o"%backupdir%\" -mx=4
	)
tasklist /fi "imagename eq firefox.exe" |find ":" >nul
if errorlevel 1 taskkill /f /im "firefox.exe"
if exist "%localappdata%\Mozilla\Firefox\Profiles\" (
	echo Creating Mozilla Firefox profile backup ... &echo.
	7za.exe a "%backupdir%\firefox_%date%.7z" "%localappdata%\Mozilla\Firefox\Profiles\" -o"%backupdir%\" -mx=4
	)
tasklist /fi "imagename eq vivaldi.exe" |find ":" >nul
if errorlevel 1 taskkill /f /im "vivaldi.exe"
if exist "%localappdata%\Vivaldi\User Data\Default\" (
	echo Creating Vivaldi profile backup ... &echo.
	7za.exe a "%backupdir%\vivaldy_%date%.7z" "%localappdata%\Vivaldi\User Data\Default\" -o"%backupdir%\" -mx=4
	)
tasklist /fi "imagename eq thunderbird.exe" |find ":" >nul
if errorlevel 1 taskkill /f /im "thunderbird.exe"
if exist "%localappdata%\Thunderbird\Profiles\" ( 
	echo Creating Thunderbird profile backup ... &echo.
	7za.exe a "%backupdir%\thunderbird_%date%.7z" "%localappdata%\Thunderbird\Profiles\" -o"%backupdir%\" -mx=4
	)
::
:completed
title %0 - task is completed
if "%ntver%"=="10.0" echo [30;102mPRESS ANY KEY TO EXIT[0m
if "%ntver%" neq "10.0" (
	echo PRESS ANY KEY TO EXIT
	color 0a
	)
pause >nul
exit
::
:get7z
if not exist "%sysinstall%\wget.exe" (
	echo [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls" >getwget.ps1
	echo Invoke-WebRequest 'http://eternallybored.org/misc/wget/1.20.3/32/wget.exe' -OutFile 'wget.exe' >>getwget.ps1
	powershell -ExecutionPolicy Bypass -File getwget.ps1
	if not exist "%sysinstall%\wget.exe" (
		echo. &echo Now we will start IE for downloading wget.exe, save it in the same dir with sysinstall.cmd and close browser window.&color 0e &pause
		"%programfiles%\internet explorer\iexplore.exe" "http://eternallybored.org/misc/wget/1.20.3/32/wget.exe"
		)
	del /f /q getwget.ps1 >nul
	echo Ok, now we should have wget.exe
	)
if not exist "%setupbin%" md "%setupbin%"
cd "%setupbin%"
if "%osarch%"=="x86" goto osx86_7z
if "%osarch%"=="x64" goto osx64_7z
:osx86_7z
echo. &echo Installing 7-zip 32-bit ...
tasklist /fi "imagename eq 7zfm.exe" |find ":" >nul
if errorlevel 1 taskkill /f /im "7zfm.exe"
if not exist "%setupbin%\7z2501.msi" wget.exe --tries=3 --no-check-certificate -c "http://7-zip.org/a/7z2501.msi"
if not exist "%setupbin%\7z2501.msi" wget.exe --tries=3 --no-check-certificate -c "http://netcologne.dl.sourceforge.net/project/sevenzip/7-Zip/25.01/7z2501.msi"
msiexec /package "%setupbin%\7z2501.msi" /quiet /norestart
if not exist "%setupbin%\7z2501-extra.7z" wget.exe --tries=3 --no-check-certificate -c "http://www.7-zip.org/a/7z2501-extra.7z"
if not exist "%setupbin%\7z2501-extra.7z" wget.exe --tries=3 --no-check-certificate -c "http://netcologne.dl.sourceforge.net/project/sevenzip/7-Zip/25.01/7z2501-extra.7z"
"%ProgramFiles%\7-Zip\7zg.exe" x -r -y -o"%ProgramFiles%\7-Zip" "%setupbin%\7z2501-extra.7z"
if not exist "%sysinstall%"\7za.exe copy /y "%ProgramFiles%\7-Zip\7za.exe" "%sysinstall%"
copy /y "%ProgramFiles%\7-Zip\7za.exe" "%systemroot%\system32"
goto startbackup
:osx64_7z
echo. &echo Installing 7-zip 64-bit ...
tasklist /fi "imagename eq 7zfm.exe" |find ":" >nul
if errorlevel 1 taskkill /f /im "7zfm.exe"
if not exist "%setupbin%\7z2501-x64.msi" wget.exe --tries=3 --no-check-certificate -c "http://7-zip.org/a/7z2501-x64.msi"
if not exist "%setupbin%\7z2501-x64.msi" wget.exe --tries=3 --no-check-certificate -c "http://netcologne.dl.sourceforge.net/project/sevenzip/7-Zip/25.01/7z2501-x64.msi"
msiexec /package "%setupbin%\7z2501-x64.msi" /quiet /norestart
if not exist "%setupbin%\7z2501-extra.7z" wget.exe --tries=3 --no-check-certificate -c "http://www.7-zip.org/a/7z2501-extra.7z"
if not exist "%setupbin%\7z2501-extra.7z" wget.exe --tries=3 --no-check-certificate -c "http://netcologne.dl.sourceforge.net/project/sevenzip/7-Zip/25.01/7z2501-extra.7z"
if exist "%ProgramFiles%\7-Zip" set sevenzip=%ProgramFiles%\7-Zip
if not exist "%ProgramFiles%\7-Zip" set sevenzip=%ProgramFiles(x86)%\7-Zip
"%sevenzip%\7zg.exe" x -r -y -o"%sevenzip%" "%setupbin%\7z2501-extra.7z"
if not exist "%sysinstall%\7za.exe" copy /y "%sevenzip%\x64\7za.exe" "%sysinstall%"
copy /y "%sevenzip%\x64\7za.exe" "%systemroot%\system32"
goto startbackup
::
