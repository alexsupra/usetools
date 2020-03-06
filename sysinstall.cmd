:: sysinstall.cmd - software and settings installation script providing better defaults
:: for 32/64-bits OS Windows NT 6.1, 6.2, 6.3, 10.0
:: https://github.com/alexsupra/usetools
@echo off &cls
chcp 866 >nul
for /f "tokens=2*" %%a in ('reg query "hklm\hardware\description\system\centralprocessor\0" /v "ProcessorNameString"') do set "cpuname=%%b"
echo %cpuname%
:: checking admin previligies
net session >nul 2>&1
if %errorLevel% neq 0 echo Administrative permissions check failure! &echo Please restart as admin. &color 0e &pause &exit
:: checking os version
::for /f "tokens=2*" %%a in ('reg query "hklm\software\microsoft\windows nt\currentversion" /v "CurrentVersion"') do set "ntver=%%b"
for /f "tokens=4-5 delims=. " %%i in ('ver') do set ntver=%%i.%%j
if "%ntver%"=="4.0" echo OS Windows NT %ntver% is not supported &color 0e &pause
if "%ntver%"=="5.0" echo OS Windows NT %ntver% is not supported &color 0e &pause
if "%ntver%"=="5.1" echo OS Windows NT %ntver% is not supported &color 0e &pause
if "%ntver%"=="5.2" echo OS Windows NT %ntver% is not supported &color 0e &pause
echo CPU architecture is detected as: %PROCESSOR_ARCHITECTURE% &echo OS version: NT %ntver%
echo     ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
echo     ÛÛ    ÛÛ ÛÛßßßßÛÛ ÛßßßßßßÛ ßßßÛÛßßß ÛßßßßßßÛ ÛßßßßßßÛ ÛÛ       ÛÛßßßßÛÛ 
echo     ÛÛ    ÛÛ ÛÛ       Û           ÛÛ    Û      Û Û      Û ÛÛ       ÛÛ       
echo     ÛÛ    ÛÛ  ßßßßßßÛ Ûßßßßß      ÛÛ    Û      Û Û      Û ÛÛ        ßßßßßßÛ  
echo     ÛÛ    ÛÛ ÛÛ     Û Û      Û    ÛÛ    Û      Û Û      Û ÛÛ    ÛÛ ÛÛ     Û 
echo      ßßßßßßß ßßßßßßßß ßßßßßßßß    ßß    ßßßßßßßß ßßßßßßßß ßßßßßßßß ßßßßßßßß  
echo     ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
echo     ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
echo     ³   usetools sysinstall - software and settings installation script   ³
echo     ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cd /d "%~dp0"
set sysinstall=%cd%
set setupbin=%cd%\setupbin
set setupcfg=%cd%\setupcfg
set backup=%cd%\backup
if "%1"=="-u" (
	echo. &echo Running in unattended mode... 
	set userinput=1
	goto prepair
	)
::
:menu
echo. &color 0a
echo [1] Install system settings and software
echo [2] Install system settings
echo [3] Install software
echo [4] Make system registry backup
echo [5] Restore system from registry backup
echo [9] Reboot
echo [0] Exit &echo.
set userinput=0
set /p userinput=Input your choice and press enter [1/2/3/4/5/9/0]:
if %userinput%==0 exit
if %userinput%==1 goto prepair
if %userinput%==2 goto prepair
if %userinput%==3 goto prepair
if %userinput%==4 goto backup
if %userinput%==5 goto restore
if %userinput%==9 goto reboot
echo Input seems to be incorrect. Please try one more time.
goto menu
::
:backup
echo Making system registry backup...
if not exist "%backup%" md "%backup%"
reg export "hkey_local_machine" "%backup%\hklm.reg"
reg export "hkey_classes_root" "%backup%\hkcr.reg"
reg export "hkey_current_user" "%backup%\hkcu.reg"
reg export "hkey_users\.default" "%backup%\hkud.reg"
if %userinput%==4 goto menu
::
:restore
echo Restoring system from registry backup...
if not exist "%backup%" echo Backup not found &goto menu
if exist "%backup%\hklm.reg" regedit /s "%backup%\hklm.reg"
if exist "%backup%\hkcr.reg" regedit /s "%backup%\hkcr.reg"
if exist "%backup%\hkcu.reg" regedit /s "%backup%\hkcu.reg"
if exist "%backup%\hkud.reg" regedit /s "%backup%\hkud.reg"
if %userinput%==5 goto menu
::
:prepair
if not exist "%setupbin%" md "%setupbin%"
if not exist "%setupcfg%" md "%setupcfg%"
set path=%path%;%sysinstall%;%setupbin%
if not exist "%sysinstall%\wget.exe" (
	powershell -command "& { Invoke-WebRequest 'http://eternallybored.org/misc/wget/1.20.3/32/wget.exe' -OutFile 'wget.exe' }"
	if not exist "%sysinstall%\wget.exe" (
		echo We have a problem: wget.exe is not found! &echo Now we will start IE for downloading wget.exe, please save it in the same dir with sysinstall.cmd &color 0e &pause
		"%programfiles%\internet explorer\iexplore.exe" "http://eternallybored.org/misc/wget/1.20.3/32/wget.exe"
		)
	goto prepair
	)
if %userinput%==3 goto install
::
:config
if not exist "%sysinstall%\sysconfig.reg" wget.exe --tries=3 --no-check-certificate -c "http://github.com/alexsupra/usetools/raw/master/sysconfig.reg"
echo Applying general system settings...
regedit /s "%sysinstall%\sysconfig.reg"
if "%ntver%"=="6.2" (
	if not exist "%sysinstall%\sysconfig_win8x.reg" wget.exe --tries=3 --no-check-certificate -c "http://github.com/alexsupra/usetools/raw/master/sysconfig_win8x.reg"
	echo Applying additional system settings...
	regedit /s "%sysinstall%\sysconfig_win8x.reg"
	)
if "%ntver%"=="6.3" (
	if not exist "%sysinstall%\sysconfig_win8x.reg" wget.exe --tries=3 --no-check-certificate -c "http://github.com/alexsupra/usetools/raw/master/sysconfig_win8x.reg"
	echo Applying additional system settings...
	regedit /s "%sysinstall%\sysconfig_win8x.reg"
	)
if "%ntver%"=="10.0" (
	if not exist "%sysinstall%\sysconfig_win10.reg" wget.exe --tries=3 --no-check-certificate -c "http://github.com/alexsupra/usetools/raw/master/sysconfig_win10.reg"
	echo Applying additional system settings...
	regedit /s "%sysinstall%\sysconfig_win10.reg"
	)
if %userinput%==2 goto menu
::
:install
color 0b
cd "%setupbin%"
wmic OS get OSArchitecture|find.exe "64" >nul 
if not errorlevel 1 (
	set osarch=x64
	goto osx64
	)
set osarch=x86
::
:osx86
echo Running installation in 32-bit mode...
:: 7-zip
if not exist "%setupbin%\7z1900.msi" wget.exe --tries=2 --no-check-certificate -c "http://netcologne.dl.sourceforge.net/project/sevenzip/7-Zip/19.00/7z1900.msi"
if not exist "%setupbin%\7z1900.msi" wget.exe --tries=1 --no-check-certificate -c "http://www.7-zip.org/a/7z1900.msi"
msiexec /package "%setupbin%\7z1900.msi" /quiet /norestart
if not exist "%setupbin%\7z1900-extra.7z" wget.exe --tries=2 --no-check-certificate -c "http://netcologne.dl.sourceforge.net/project/sevenzip/7-Zip/19.00/7z1900-extra.7z"
if not exist "%setupbin%\7z1900-extra.7z" wget.exe --tries=1 --no-check-certificate -c "http://www.7-zip.org/a/7z1900-extra.7z"
"%ProgramFiles%\7-Zip\7zg.exe" x -r -y -o"%ProgramFiles%\7-Zip" "%setupbin%\7z1900-extra.7z"
copy /y "%ProgramFiles%\7-Zip\7za.exe" "%sysinstall%"
copy /y "%ProgramFiles%\7-Zip\7za.exe" "%systemroot%\system32"
:: NirCMD
if not exist "%setupbin%\nircmd.zip" wget.exe --tries=3 --no-check-certificate -c "http://www.nirsoft.net/utils/nircmd.zip"
7za.exe x -r -y -x!*.chm -o"%sysinstall%" "%setupbin%\nircmd.zip"
copy /y "%sysinstall%\nircmd.exe" "%systemroot%\system32"
copy /y "%sysinstall%\nircmdc.exe" "%systemroot%\system32"
:: FAR
if not exist "%setupbin%\Far30b5511.x86.20191120.msi" wget.exe --tries=3 --no-check-certificate -c "http://www.farmanager.com/files/Far30b5511.x86.20191120.msi"
msiexec /package "%setupbin%\Far30b5511.x86.20191120.msi" /quiet /norestart
if not exist "%ProgramFiles%\Far Manager\plugins\7-zip" md "%ProgramFiles%\Far Manager\plugins\7-zip"
copy /y "%ProgramFiles%\7-Zip\far\*.*" "%ProgramFiles%\Far Manager\plugins\7-zip"
regedit /s "%ProgramFiles%\Far Manager\plugins\7-zip\far7z.reg"
cd "%setupcfg%"
if not exist "%setupcfg%\far.7z" wget.exe --tries=3 --no-check-certificate -c "http://github.com/alexsupra/usetools/raw/master/setupcfg/far.7z"
7za.exe x -r -y -o"%appdata%" "%setupcfg%\far.7z"
echo "%ProgramFiles%\Far Manager\far.exe" >%systemroot%\system32\far.cmd
cd "%setupbin%"
:: ConEmu
if not exist "%setupbin%\ConEmuSetup.190714.exe" wget.exe --tries=3 --no-check-certificate -c "http://excellmedia.dl.sourceforge.net/project/conemu/Alpha/ConEmuSetup.190714.exe"
"%setupbin%\ConEmuSetup.190714.exe" /p:x86,adm /qr
cd "%setupcfg%"
if not exist "%setupcfg%\conemu.7z" wget.exe --tries=3 --no-check-certificate -c "http://github.com/alexsupra/usetools/raw/master/setupcfg/conemu.7z"
7za.exe x -r -y -o"%programfiles%" "%setupcfg%\conemu.7z"
copy /y "%programfiles%\conemu\conemu.xml" "%appdata%"
del /f /q "%userprofile%\desktop\ConEmu.lnk"
cd "%setupbin%"
:: Anvir
nircmdc.exe killprocess anvir.exe
if not exist "%setupbin%\anvirrus.zip" wget.exe --tries=3 --no-check-certificate -c "http://www.anvir.net/downloads/anvirrus.zip"
7za.exe x -r -y -o"%setupbin%" "%setupbin%\anvirrus.zip"
if not exist "%programfiles%\anvir" md "%programfiles%\anvir"
7za.exe x -r -y -o"%programfiles%\anvir" "%setupbin%\anvirrus-portable.zip"
cd "%setupcfg%"
if not exist "%setupcfg%\anvir.7z" wget.exe --tries=3 --no-check-certificate -c "http://github.com/alexsupra/usetools/raw/master/setupcfg/anvir.7z"
7za.exe x -r -y -o"%programfiles%\anvir" "%setupcfg%\anvir.7z"
reg add "hkcu\software\microsoft\windows\currentversion\run" /v "anvir task manager" /t reg_sz /d "%programfiles%\anvir\anvir.exe minimized" /f
nircmdc.exe shortcut "%programfiles%\anvir\anvir.exe" "~$folder.common_programs$" "Anvir"
echo cd /d "%programfiles%\anvir" >%systemroot%\system32\anvir.cmd
echo start /high anvir.exe >>%systemroot%\system32\anvir.cmd
cd "%setupbin%"
:: UninstallView
if not exist "%setupbin%\uninstallview.zip" wget.exe --tries=3 --no-check-certificate -c "http://www.nirsoft.net/utils/uninstallview.zip"
if not exist "%programfiles%\uninstallview" md "%programfiles%\uninstallview"
7za.exe x -r -y -o"%programfiles%\uninstallview" "%setupbin%\uninstallview.zip"
nircmdc.exe shortcut "%programfiles%\uninstallview\uninstallview.exe" "~$folder.common_programs$" "UninstallView"
:: ClamWin
if not exist "%setupbin%\clamwin-0.99.4-setup.exe" wget.exe --tries=3 --no-check-certificate -c "http://downloads.sourceforge.net/clamwin/clamwin-0.99.4-setup.exe"
"%setupbin%\clamwin-0.99.4-setup.exe" /VERYSILENT
:: Notepad2
if not exist "%setupbin%\notepad2_4.2.25_x86.zip" wget.exe --tries=3 --no-check-certificate -c "http://www.flos-freeware.ch/zip/notepad2_4.2.25_x86.zip"
cd "%setupcfg%"
if not exist "%setupcfg%\notepad2.7z" wget.exe --tries=3 --no-check-certificate -c "http://github.com/alexsupra/usetools/raw/master/setupcfg/notepad2.7z"
cd "%setupbin%"
:: Notepad++
if not exist "%setupbin%\npp.7.8.1.Installer.exe" wget.exe --tries=3 --no-check-certificate -c "http://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v7.8.1/npp.7.8.1.Installer.exe"
"%setupbin%\npp.7.8.1.Installer.exe" /S
:: Firefox
if not exist "%setupbin%\Firefox Setup 73.0.1.exe" wget.exe --tries=3 --no-check-certificate -c "http://ftp.mozilla.org/pub/firefox/releases/73.0.1/win32/ru/Firefox Setup 73.0.1.exe"
"%setupbin%\Firefox Setup 73.0.1.exe" /S
:: Thunderbird
if not exist "%setupbin%\Thunderbird Setup 68.4.2.exe" wget.exe --tries=3 --no-check-certificate -c "http://download-installer.cdn.mozilla.net/pub/thunderbird/releases/68.4.2/win32/ru/Thunderbird Setup 68.4.2.exe"
"%setupbin%\Thunderbird Setup 68.4.2.exe" /S
::if not exist "%setupbin%\addon-362387-latest.xpi" wget.exe --tries=3 --no-check-certificate -c "http://addons.thunderbird.net/thunderbird/downloads/latest/custom-address-sidebar/addon-362387-latest.xpi"
::copy /y "%setupbin%\addon-362387-latest.xpi" "%programfiles%\Mozilla Thunderbird\extensions"
:: VLCVideoPlayer
if not exist "%setupbin%\vlc-3.0.8-win32.exe" wget.exe --tries=3 --no-check-certificate -c "http://ftp.lysator.liu.se/pub/videolan/vlc/3.0.8/win32/vlc-3.0.8-win32.exe"
"%setupbin%\vlc-3.0.8-win32.exe" /S
:: PureText
if not exist "%setupbin%\puretext_6.2_32-bit.zip" wget.exe --tries=3 --no-check-certificate -c "http://stevemiller.net/downloads/puretext_6.2_32-bit.zip"
if not exist "%programfiles%\puretext" md "%programfiles%\puretext"
7za.exe x -r -y -o"%programfiles%\puretext" "%setupbin%\puretext_6.2_32-bit.zip"
nircmdc.exe shortcut "%programfiles%\puretext\puretext.exe" "~$folder.common_programs$" "PureText"
goto osx8664
::
:osx64
echo Running installation in 64-bit mode...
if "%PROCESSOR_ARCHITECTURE%"=="x86" color 0e &echo CMD process seems to be 32-bit, its recommended to restart in 64-bit &pause
:: 7-zip
if not exist "%setupbin%\7z1900-x64.msi" wget.exe --tries=2 --no-check-certificate -c "http://netcologne.dl.sourceforge.net/project/sevenzip/7-Zip/19.00/7z1900-x64.msi"
if not exist "%setupbin%\7z1900-x64.msi" wget.exe --tries=1 --no-check-certificate -c "http://www.7-zip.org/a/7z1900-x64.msi"
msiexec /package "%setupbin%\7z1900-x64.msi" /quiet /norestart
if not exist "%setupbin%\7z1900-extra.7z" wget.exe --tries=2 --no-check-certificate -c "http://netcologne.dl.sourceforge.net/project/sevenzip/7-Zip/19.00/7z1900-extra.7z"
if not exist "%setupbin%\7z1900-extra.7z" wget.exe --tries=1 --no-check-certificate -c "http://www.7-zip.org/a/7z1900-extra.7z"
if exist "%ProgramFiles%\7-Zip" set sevenzip=%ProgramFiles%\7-Zip
if not exist "%ProgramFiles%\7-Zip" set sevenzip=%ProgramFiles(x86)%\7-Zip
"%sevenzip%\7zg.exe" x -r -y -o"%sevenzip%" "%setupbin%\7z1900-extra.7z"
copy /y "%sevenzip%\x64\7za.exe" "%sysinstall%"
copy /y "%sevenzip%\x64\7za.exe" "%systemroot%\system32"
:: NirCMD
if not exist "%setupbin%\nircmd-x64.zip" wget.exe --tries=3 --no-check-certificate -c "http://www.nirsoft.net/utils/nircmd-x64.zip"
7za.exe x -r -y -x!*.chm -o"%sysinstall%" "%setupbin%\nircmd-x64.zip"
copy /y "%sysinstall%\nircmd.exe" "%systemroot%\system32"
copy /y "%sysinstall%\nircmdc.exe" "%systemroot%\system32"
:: FAR
if not exist "%setupbin%\Far30b5511.x64.20191120.msi" wget.exe --tries=3 --no-check-certificate -c "http://www.farmanager.com/files/Far30b5511.x64.20191120.msi"
msiexec /package "%setupbin%\Far30b5511.x64.20191120.msi" /quiet /norestart
if not exist "%ProgramFiles%\Far Manager\plugins\7-zip" md "%ProgramFiles%\Far Manager\plugins\7-zip"
copy /y "%ProgramFiles%\7-Zip\far\*.*" "%ProgramFiles%\Far Manager\plugins\7-zip"
regedit /s "%ProgramFiles%\Far Manager\plugins\7-zip\far7z.reg"
cd "%setupcfg%"
if not exist "%setupcfg%\far.7z" wget.exe --tries=3 --no-check-certificate -c "http://github.com/alexsupra/usetools/raw/master/setupcfg/far.7z"
7za.exe x -r -y -o"%appdata%" "%setupcfg%\far.7z"
echo "%ProgramFiles%\Far Manager\far.exe" >%systemroot%\system32\far.cmd
cd "%setupbin%"
:: ConEmu
if not exist "%setupbin%\ConEmuSetup.190714.exe" wget.exe --tries=3 --no-check-certificate -c "http://excellmedia.dl.sourceforge.net/project/conemu/Alpha/ConEmuSetup.190714.exe"
"%setupbin%\ConEmuSetup.190714.exe" /p:x64,adm /qr
cd "%setupcfg%"
if not exist "%setupcfg%\conemu.7z" wget.exe --tries=3 --no-check-certificate -c "http://github.com/alexsupra/usetools/raw/master/setupcfg/conemu.7z"
7za.exe x -r -y -o"%programfiles%" "%setupcfg%\conemu.7z"
copy /y "%programfiles%\conemu\conemu.xml" "%appdata%"
del /f /q "%userprofile%\desktop\ConEmu (x64).lnk"
cd "%setupbin%"
:: Anvir
nircmdc.exe killprocess anvir.exe
if not exist "%setupbin%\anvirrus.zip" wget.exe --tries=3 --no-check-certificate -c "http://www.anvir.net/downloads/anvirrus.zip"
7za.exe x -r -y -o"%setupbin%" "%setupbin%\anvirrus.zip"
if not exist "%programfiles%\anvir" md "%programfiles%\anvir"
7za.exe x -r -y -o"%programfiles%\anvir" "%setupbin%\anvirrus-portable.zip"
cd "%setupcfg%"
if not exist "%setupcfg%\anvir.7z" wget.exe --tries=3 --no-check-certificate -c "http://github.com/alexsupra/usetools/raw/master/setupcfg/anvir.7z"
7za.exe x -r -y -o"%programfiles%\anvir" "%setupcfg%\anvir.7z"
reg add "hkcu\software\microsoft\windows\currentversion\run" /v "anvir task manager" /t reg_sz /d "%programfiles%\anvir\anvir.exe minimized" /f
nircmdc.exe shortcut "%programfiles%\anvir\anvir.exe" "~$folder.common_programs$" "Anvir"
echo cd /d "%programfiles%\anvir" >%systemroot%\system32\anvir.cmd
echo start /high anvir.exe >>%systemroot%\system32\anvir.cmd
cd "%setupbin%"
:: UninstallView
if not exist "%setupbin%\uninstallview-x64.zip" wget.exe --tries=3 --no-check-certificate -c "http://www.nirsoft.net/utils/uninstallview-x64.zip"
if not exist "%programfiles%\uninstallview" md "%programfiles%\uninstallview"
7za.exe x -r -y -o"%programfiles%\uninstallview" "%setupbin%\uninstallview-x64.zip"
nircmdc.exe shortcut "%programfiles%\uninstallview\uninstallview.exe" "~$folder.common_programs$" "UninstallView"
:: ClamWin
if not exist "%setupbin%\clamwin-0.99.4-setup.exe" wget.exe --tries=3 --no-check-certificate -c "http://downloads.sourceforge.net/clamwin/clamwin-0.99.4-setup.exe"
"%setupbin%\clamwin-0.99.4-setup.exe" /VERYSILENT
:: Notepad2
if not exist "%setupbin%\notepad2_4.2.25_x64.zip" wget.exe --tries=3 --no-check-certificate -c "http://www.flos-freeware.ch/zip/notepad2_4.2.25_x64.zip"
cd "%setupcfg%"
if not exist "%setupcfg%\notepad2.7z" wget.exe --tries=3 --no-check-certificate -c "http://github.com/alexsupra/usetools/raw/master/setupcfg/notepad2.7z"
cd "%setupbin%"
:: Notepad++
if not exist "%setupbin%\npp.7.8.1.Installer.x64.exe" wget.exe --tries=3 --no-check-certificate -c "http://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v7.8.1/npp.7.8.1.Installer.x64.exe"
"%setupbin%\npp.7.8.1.Installer.x64.exe" /S
:: Firefox
if not exist "%setupbin%\Firefox Setup 73.0.1.msi" wget.exe --tries=3 --no-check-certificate -c "http://ftp.mozilla.org/pub/firefox/releases/73.0.1/win64/ru/Firefox Setup 73.0.1.msi"
msiexec /package "%setupbin%\Firefox Setup 73.0.1.msi" /quiet /norestart
::if not exist "%programfiles%\mozilla firefox\browser\default" md "%programfiles%\mozilla firefox\browser\default"
::echo user_pref("browser.urlbar.placeholderName", "Google"); >"%programfiles%\mozilla firefox\browser\default\prefs.js"
:: Thunderbird
if not exist "%setupbin%\Thunderbird Setup 68.4.2.msi" wget.exe --tries=3 --no-check-certificate -c "http://download-installer.cdn.mozilla.net/pub/thunderbird/releases/68.4.2/win64/ru/Thunderbird Setup 68.4.2.msi"
msiexec /package "%setupbin%\Thunderbird Setup 68.4.2.msi" /quiet /norestart
::if not exist "%setupbin%\addon-362387-latest.xpi" wget.exe --tries=3 --no-check-certificate -c "http://addons.thunderbird.net/thunderbird/downloads/latest/custom-address-sidebar/addon-362387-latest.xpi"
::copy /y "%setupbin%\addon-362387-latest.xpi" "%programfiles%\Mozilla Thunderbird\extensions"
:: VLCVideoPlayer
if not exist "%setupbin%\vlc-3.0.8-win64.exe" wget.exe --tries=3 --no-check-certificate -c "http://ftp.acc.umu.se/mirror/videolan.org/vlc/3.0.8/win64/vlc-3.0.8-win64.exe"
"%setupbin%\vlc-3.0.8-win64.exe" /S
:: PureText
if not exist "%setupbin%\puretext_6.2_64-bit.zip" wget.exe --tries=3 --no-check-certificate -c "http://stevemiller.net/downloads/puretext_6.2_64-bit.zip"
if not exist "%programfiles%\puretext" md "%programfiles%\puretext"
7za.exe x -r -y -o"%programfiles%\puretext" "%setupbin%\puretext_6.2_64-bit.zip"
nircmdc.exe shortcut "%programfiles%\puretext\puretext.exe" "~$folder.common_programs$" "PureText"
::
:osx8664
reg delete "HKEY_CLASSES_ROOT\Directory\shell\AddToPlaylistVLC" /f
reg delete "HKEY_CLASSES_ROOT\Directory\shell\PlayWithVLC" /f
nircmdc.exe shortcut "%programfiles%\videolan\vlc\vlc.exe" "~$folder.appdata$\microsoft\windows\sendto" "VLC"
:: Unreal Commander
if not exist "%setupbin%\uncomsetup.exe" wget.exe --tries=3 --no-check-certificate -c "http://x-diesel.com/download/uncomsetup.exe"
"%setupbin%\uncomsetup.exe" /VERYSILENT
nircmdc.exe killprocess UnrealCommander32.exe
nircmdc.exe killprocess UnrealCommander64.exe
if %osarch%==x86 (
	taskkill /IM "UnrealCommander32.exe" /F
	7za.exe x -r -y -o"%systemdrive%\unreal commander" "%setupbin%\notepad2_4.2.25_x86.zip"	
	)
if %osarch%==x64 (
	taskkill /IM "UnrealCommander64.exe" /F
	7za.exe x -r -y -o"%systemdrive%\unreal commander" "%setupbin%\notepad2_4.2.25_x64.zip"
	)
cd "%setupcfg%"
if not exist "%setupcfg%\unreal.7z" wget.exe --tries=3 --no-check-certificate -c "http://github.com/alexsupra/usetools/raw/master/setupcfg/unreal.7z"
7za.exe x -r -y -o"%systemdrive%\unreal commander" "%setupcfg%\unreal.7z"
copy /y "%systemdrive%\unreal commander\uncom.ini" "%appdata%\unreal commander"
copy /y "%systemdrive%\unreal commander\uncomstyles.ini" "%appdata%\unreal commander"
7za.exe x -r -y -o"%systemdrive%\unreal commander" "%setupcfg%\notepad2.7z"
reg delete "HKEY_CLASSES_ROOT\directory\shell\ Unreal Commander" /f >nul
cd "%setupbin%"
:: OpenOffice
if not exist "%setupbin%\Apache_OpenOffice_4.1.7_Win_x86_install_ru.exe" wget.exe --tries=3 --no-check-certificate -c "http://netcologne.dl.sourceforge.net/project/openofficeorg.mirror/4.1.7/binaries/ru/Apache_OpenOffice_4.1.7_Win_x86_install_ru.exe"
"%setupbin%\Apache_OpenOffice_4.1.7_Win_x86_install_ru.exe" /S
rundll32.exe advpack.dll,DelNodeRunDLL32 "%userprofile%\desktop\OpenOffice 4.1.7 (ru) Installation Files"
:: XnView
if not exist "%setupbin%\XnView-win-full.exe" wget.exe --tries=3 --no-check-certificate -c "http://download.xnview.com/XnView-win-full.exe"
"%setupbin%\XnView-win-full.exe" /VERYSILENT
:: Foxit Reader
if not exist "%setupbin%\FoxitReader971_L10N_Setup_Prom.exe" wget.exe --tries=3 --no-check-certificate -c "http://cdn01.foxitsoftware.com/product/reader/desktop/win/9.7.1/C3DE0FFDF926B5E670543028BF47B076/FoxitReader971_L10N_Setup_Prom.exe"
"%setupbin%\FoxitReader971_L10N_Setup_Prom.exe" /silent
:: foobar2000
::if not exist "%setupbin%\foobar2000_v1.5.1.exe" wget.exe --tries=3 --no-check-certificate -c "https://www.videohelp.com/download-HSqJsNkrXFM/foobar2000_v1.5.1.exe"
::"%setupbin%\foobar2000_v1.5.1.exe" /S
:: XMPlay
if not exist "%setupbin%\xmplay38.zip" wget.exe --tries=3 --no-check-certificate -c "http://www.un4seen.com/files/xmplay38.zip"
if not exist "%programfiles%\xmplay" md "%programfiles%\xmplay"
7za.exe x -r -y -o"%programfiles%\xmplay" "%setupbin%\xmplay38.zip"
nircmdc.exe shortcut "%programfiles%\xmplay\xmplay.exe" "~$folder.appdata$\microsoft\windows\sendto" "XMPlay"
:: WinDirStat
if not exist "%setupbin%\wds_current_setup.exe" wget.exe --tries=3 --no-check-certificate -c "http://windirstat.net/wds_current_setup.exe"
"%setupbin%\wds_current_setup.exe" /S
del /f /q "%userprofile%\desktop\WinDirStat.lnk"
:: HWMonitor
if not exist "%setupbin%\hwmonitor_1.40.exe" wget.exe --tries=3 --no-check-certificate -c "http://download.cpuid.com/hwmonitor/hwmonitor_1.40.exe"
"%setupbin%\hwmonitor_1.40.exe" /VERYSILENT
del /f /q "%public%\desktop\CPUID HWMonitor.lnk"
:: Keyboard LEDs
if not exist "%setupbin%\keyboard-leds.exe" wget.exe --tries=2 --no-check-certificate -c "http://keyboard-leds.com/files/keyboard-leds.exe"
"%setupbin%\keyboard-leds.exe" /S
del /f /q "%public%\desktop\Keyboard LEDs.lnk"
:: DotnetFX 3.5
DISM /Online /Enable-Feature /FeatureName:NetFx3 /All
::if not exist "%setupbin%\dotnetfx35.exe" wget.exe --tries=3 --no-check-certificate -c "http://download.microsoft.com/download/2/0/e/20e90413-712f-438c-988e-fdaa79a8ac3d/dotnetfx35.exe"
::"%setupbin%\dotnetfx35.exe" /s
:: Classic Shell
if not exist "%setupbin%\ClassicShellSetup_4_3_1-ru.exe" wget.exe --tries=3 --no-check-certificate -c "http://netcologne.dl.sourceforge.net/project/classicshell/Version 4.3.1 general release/ClassicShellSetup_4_3_1-ru.exe"
if "%ntver%" neq "6.1" "%setupbin%\ClassicShellSetup_4_3_1-ru.exe" /quiet
:: Tango Patcher
if not exist "%setupbin%\WinTango-Patcher-16.12.24-offline.exe" wget.exe --tries=3 --no-check-certificate -c "http://github.com/heebijeebi/WinTango-Patcher/releases/download/v16.12.24/WinTango-Patcher-16.12.24-offline.exe"
nircmdc.exe initshutdown "sysinstall: system will be restarted automatically in a 7 min" 420 force reboot
"%setupbin%\WinTango-Patcher-16.12.24-offline.exe" /S
::
color 2f &echo Installation completed
if "%1"=="-u" goto reboot
pause
:reboot
echo Restarting system...
shutdown /r /f
::