:: usetools sysinstall
@echo off &cls
chcp 866 >nul
for /f "tokens=2*" %%a in ('reg query "hklm\hardware\description\system\centralprocessor\0" /v "ProcessorNameString"') do set "cpuname=%%b"
for /f "tokens=2*" %%a in ('reg query "hklm\software\microsoft\windows nt\currentversion" /v "CurrentVersion"') do set "ntver=%%b"
echo %cpuname%
:: checking admin previligies
net session >nul 2>&1
if %errorLevel% neq 0 echo Administrative permissions check failure! &echo Please restart as admin. &color 0e &pause &exit
:: checking os version
if "%ntver%"=="4.0" echo OS Windows NT %ntver% is not supported &color 0e &pause
if "%ntver%"=="5.0" echo OS Windows NT %ntver% is not supported &color 0e &pause
if "%ntver%"=="5.1" echo OS Windows NT %ntver% is not supported &color 0e &pause
echo CPU architecture is detected as: %PROCESSOR_ARCHITECTURE% &echo OS version: %ntver% &echo.
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
::
:menu
echo. &color 0a
echo [1] Install software and system settings
echo [2] Install software
echo [0] Exit &echo.
set userinput=0
set /p userinput=  Input your choice and press enter [1/2/0]:
if %userinput%==0 exit
if %userinput%==2 goto prepair
if %userinput%==1 goto prepair
echo Input seems to be incorrect. Please try one more time.
goto menu
::
:prepair
cd /d "%~dp0"
set sysinstall=%cd%
set setupbin=%cd%\setupbin
set setupcfg=%cd%\setupcfg
if not exist %setupbin% md %setupbin%
if not exist %setupcfg% md %setupcfg%
set path=%path%;%sysinstall%;%setupbin%
if not exist "%sysinstall%\wget.exe" (
	echo We have a problem: wget.exe is not found! &echo Now we will start IE for downloading wget.exe, please save it in the same dir with sysinstall.cmd &color 0e &pause
	"%programfiles%\internet explorer\iexplore.exe" "http://eternallybored.org/misc/wget/1.20.3/32/wget.exe"
	goto prepair
	)
color 0b
if %userinput%==1 goto config
goto install
::	
:config
echo Applying system settings...
if not exist "%sysinstall%\sysconfig.reg" wget.exe --no-check-certificate --tries=3 -c http://github.com/alexsupra/usetools/raw/master/sysconfig.reg
regedit /s "%sysinstall%\sysconfig.reg"
::
:install
cd %setupbin%
wmic OS get OSArchitecture|find.exe "64" >nul 
if not errorlevel 1 goto osx64
::
:osx86
echo Running installation in 32-bit mode...
:: 7-zip
if not exist "7z1900.msi" wget.exe --no-check-certificate --tries=2 -c http://netcologne.dl.sourceforge.net/project/sevenzip/7-Zip/19.00/7z1900.msi
if not exist "7z1900.msi" wget.exe --no-check-certificate --tries=1 -c http://www.7-zip.org/a/7z1900.msi
msiexec /package "%setupbin%\7z1900.msi" /quiet /norestart
if exist "%ProgramFiles(x86)%\7-Zip" set "sevenzip_dir"="%ProgramFiles(x86)%\7-Zip"
if exist "%ProgramFiles%\7-Zip" set "sevenzip_dir"="%ProgramFiles%\7-Zip"
if not exist "7z1900-extra.7z" wget.exe --no-check-certificate --tries=2 -c http://netcologne.dl.sourceforge.net/project/sevenzip/7-Zip/19.00/7z1900-extra.7z
if not exist "7z1900-extra.7z" wget.exe --no-check-certificate --tries=1 -c http://www.7-zip.org/a/7z1900-extra.7z
"%sevenzip_dir%\7zg.exe" x -r -y -o"%sevenzip_dir%" "%setupbin%\7z1900-extra.7z"
copy /y "%sevenzip_dir%\7za.exe" "%sysinstall%"
copy /y "%sevenzip_dir%\7za.exe" "%systemroot%\system32"
:: FAR
if not exist "Far30b5400.x86.20190523.msi" wget.exe --no-check-certificate --tries=3 -c http://www.farmanager.com/files/Far30b5400.x86.20190523.msi
msiexec /package "%setupbin%\Far30b5400.x86.20190523.msi" /quiet /norestart
if exist "%ProgramFiles(x86)%\Far Manager" set far_dir=%ProgramFiles(x86)%\Far Manager
if exist "%ProgramFiles%\Far Manager" set far_dir=%ProgramFiles%\Far Manager
if not exist "%far_dir%\plugins\7-zip" md "%far_dir%\plugins\7-zip"
copy /y "%sevenzip_dir%\far\*.*" "%far_dir%\plugins\7-zip"
regedit /s "%far_dir%\plugins\7-zip\far7z.reg"
:: ConEmu
if not exist "ConEmuSetup.190714.exe" wget.exe --no-check-certificate --tries=3 -c http://excellmedia.dl.sourceforge.net/project/conemu/Alpha/ConEmuSetup.190714.exe
"%setupbin%\ConEmuSetup.190714.exe" /p:x86,adm /qr
:: NirCMD
if not exist "nircmd.zip" wget.exe --no-check-certificate --tries=3 -c http://www.nirsoft.net/utils/nircmd.zip
7za.exe x -r -y -x!*.chm -o"%sysinstall%" "%setupbin%\nircmd.zip"
copy /y "%sysinstall%\nircmd.exe" "%systemroot%\system32"
:: Anvir
if not exist "anvirrus.zip" wget.exe --no-check-certificate --tries=3 -c http://www.anvir.net/downloads/anvirrus.zip
7za.exe x -r -y -o"%setupbin%" "%setupbin%\anvirrus.zip"
if not exist "%programfiles%\anvir" md "%programfiles%\anvir"
7za.exe x -r -y -o"%programfiles%\anvir" "%setupbin%\anvirrus-portable.zip"
cd "%setupcfg%"
if not exist "%setupcfg%\anvir.7z" wget.exe --no-check-certificate --tries=3 -c http://github.com/alexsupra/usetools/raw/master/setupcfg/anvir.7z
7za.exe x -r -y -o"%programfiles%\anvir" "%setupcfg%\anvir.7z"
reg add "hkcu\software\microsoft\windows\currentversion\run" /v "anvir task manager" /t reg_sz /d "%programfiles%\anvir\anvir.exe minimized" /f
:: ClamWin
cd "%setupbin%"
if not exist "clamwin-0.99.4-setup.exe" wget.exe --no-check-certificate --tries=3 -c "http://downloads.sourceforge.net/clamwin/clamwin-0.99.4-setup.exe"
"%setupbin%\clamwin-0.99.4-setup.exe" /VERYSILENT
:: Firefox
if not exist "Firefox Setup 67.0.4.exe" wget.exe --no-check-certificate --tries=3 -c "http://ftp.mozilla.org/pub/firefox/releases/67.0.4/win32/ru/Firefox Setup 67.0.4.exe"
"%setupbin%\Firefox Setup 67.0.4.exe" /S
:: Thunderbird
if not exist "Thunderbird Setup 60.7.2.exe" wget.exe --no-check-certificate --tries=3 -c "http://download-installer.cdn.mozilla.net/pub/thunderbird/releases/60.7.2/win32/ru/Thunderbird Setup 60.7.2.exe"
"%setupbin%\Thunderbird Setup 60.7.2.exe" /S
if not exist "addon-362387-latest.xpi" wget.exe --no-check-certificate --tries=3 -c "http://addons.thunderbird.net/thunderbird/downloads/latest/custom-address-sidebar/addon-362387-latest.xpi"
copy /y "addon-362387-latest.xpi" "%programfiles%\Mozilla Thunderbird\extensions"
::
goto osx8664
::
:osx64
echo Running installation in 64-bit mode...
if "%PROCESSOR_ARCHITECTURE%"=="x86" color 0e &echo CMD process seems to be 32-bit, its recommended to restart in 64-bit &pause
:: 7-zip
if not exist "7z1900-x64.msi" wget.exe --no-check-certificate --tries=2 -c http://netcologne.dl.sourceforge.net/project/sevenzip/7-Zip/19.00/7z1900-x64.msi
if not exist "7z1900-x64.msi" wget.exe --no-check-certificate --tries=1 -c http://www.7-zip.org/a/7z1900-x64.msi
msiexec /package "%setupbin%\7z1900-x64.msi" /quiet /norestart
if exist "%ProgramFiles(x86)%\7-Zip" set sevenzip_dir=%ProgramFiles(x86)%\7-Zip
if exist "%ProgramFiles%\7-Zip" set sevenzip_dir=%ProgramFiles%\7-Zip
if not exist "7z1900-extra.7z" wget.exe --no-check-certificate --tries=3 -c http://www.7-zip.org/a/7z1900-extra.7z
if not exist "7z1900-extra.7z" wget.exe --no-check-certificate --tries=3 -c http://netcologne.dl.sourceforge.net/project/sevenzip/7-Zip/19.00/7z1900-extra.7z
"%sevenzip_dir%\7zg.exe" x -r -y -o"%sevenzip_dir%" "%setupbin%\7z1900-extra.7z"
copy /y "%sevenzip_dir%\x64\7za.exe" "%sysinstall%"
copy /y "%sevenzip_dir%\x64\7za.exe" "%systemroot%\system32"
:: FAR
if not exist "Far30b5400.x64.20190523.msi" wget.exe --no-check-certificate --tries=3 -c http://www.farmanager.com/files/Far30b5400.x64.20190523.msi
msiexec /package "%setupbin%\Far30b5400.x64.20190523.msi" /quiet /norestart
if exist "%ProgramFiles(x86)%\Far Manager" set far_dir=%ProgramFiles(x86)%\Far Manager
if exist "%ProgramFiles%\Far Manager" set far_dir=%ProgramFiles%\Far Manager
if not exist "%far_dir%\plugins\7-zip" md "%far_dir%\plugins\7-zip"
copy /y "%sevenzip_dir%\far\*.*" "%far_dir%\plugins\7-zip"
regedit /s "%far_dir%\plugins\7-zip\far7z.reg"
:: ConEmu
if not exist "ConEmuSetup.190714.exe" wget.exe --no-check-certificate --tries=3 -c http://excellmedia.dl.sourceforge.net/project/conemu/Alpha/ConEmuSetup.190714.exe
"%setupbin%\ConEmuSetup.190714.exe" /p:x64,adm /qr
:: NirCMD
if not exist "nircmd-x64.zip" wget.exe --no-check-certificate --tries=3 -c http://www.nirsoft.net/utils/nircmd-x64.zip
7za.exe x -r -y -x!*.chm -o"%sysinstall%" "%setupbin%\nircmd-x64.zip"
copy /y "%sysinstall%\nircmd.exe" "%systemroot%\system32"
:: Anvir
if not exist "anvirrus.zip" wget.exe --no-check-certificate --tries=3 -c http://www.anvir.net/downloads/anvirrus.zip
7za.exe x -r -y -o"%setupbin%" "%setupbin%\anvirrus.zip"
if not exist "%programfiles%\anvir" md "%programfiles%\anvir"
7za.exe x -r -y -o"%programfiles%\anvir" "%setupbin%\anvirrus-portable.zip"
cd "%setupcfg%"
if not exist "%setupcfg%\anvir.7z" wget.exe --no-check-certificate --tries=3 -c http://github.com/alexsupra/usetools/raw/master/setupcfg/anvir.7z
7za.exe x -r -y -o"%programfiles%\anvir" "%setupcfg%\anvir.7z"
reg add "hkcu\software\microsoft\windows\currentversion\run" /v "anvir task manager" /t reg_sz /d "%programfiles%\anvir\anvir.exe minimized" /f
:: ClamWin
if not exist "clamwin-0.99.4-setup.exe" wget.exe --no-check-certificate --tries=3 -c "http://downloads.sourceforge.net/clamwin/clamwin-0.99.4-setup.exe"
"%setupbin%\clamwin-0.99.4-setup.exe" /VERYSILENT
:: Firefox
if not exist "Firefox Setup 67.0.4.msi" wget.exe --no-check-certificate --tries=3 -c "http://ftp.mozilla.org/pub/firefox/releases/67.0.4/win64/ru/Firefox Setup 67.0.4.msi"
msiexec /package "%setupbin%\Firefox Setup 67.0.4.msi" /quiet /norestart
::if not exist "%programfiles%\mozilla firefox\browser\default" md "%programfiles%\mozilla firefox\browser\default"
::echo user_pref("browser.urlbar.placeholderName", "Google"); >"%programfiles%\mozilla firefox\browser\default\prefs.js"
:: Thunderbird
if not exist "Thunderbird Setup 60.7.2.exe" wget.exe --no-check-certificate --tries=3 -c "http://download-installer.cdn.mozilla.net/pub/thunderbird/releases/60.7.2/win64/ru/Thunderbird Setup 60.7.2.exe"
"%setupbin%\Thunderbird Setup 60.7.2.exe" /S
if not exist "addon-362387-latest.xpi" wget.exe --no-check-certificate --tries=3 -c "http://addons.thunderbird.net/thunderbird/downloads/latest/custom-address-sidebar/addon-362387-latest.xpi"
copy /y "addon-362387-latest.xpi" "%programfiles%\Mozilla Thunderbird\extensions"
:: VLCVideoPlayer
if not exist "vlc-3.0.7.1-win64.exe" wget.exe --no-check-certificate --tries=3 -c "http://ftp.acc.umu.se/mirror/videolan.org/vlc/3.0.7.1/win64/vlc-3.0.7.1-win64.exe"
"%setupbin%\vlc-3.0.7.1-win64.exe" /S
::
:osx8664
:: OpenOffice
if not exist "%setupbin%\Apache_OpenOffice_4.1.6_Win_x86_install_ru.exe" wget.exe --no-check-certificate --tries=3 -c http://sourceforge.net/projects/openofficeorg.mirror/files/4.1.6/binaries/ru/Apache_OpenOffice_4.1.6_Win_x86_install_ru.exe
"%setupbin%\Apache_OpenOffice_4.1.6_Win_x86_install_ru.exe" /S
rundll32.exe advpack.dll,DelNodeRunDLL32 "%userprofile%\desktop\OpenOffice 4.1.6 (ru) Installation Files"
:: XnView
if not exist "XnView-win-full.exe" wget.exe --no-check-certificate --tries=3 -c "http://download.xnview.com/XnView-win-full.exe"
"%setupbin%\XnView-win-full.exe" /VERYSILENT
:: Foxit Reader
if not exist "FoxitReader95_L10N_Setup_Prom.exe" wget.exe --no-check-certificate --tries=3 -c "http://cdn09.foxitsoftware.com/product/reader/desktop/win/9.5/FoxitReader95_L10N_Setup_Prom.exe"
"%setupbin%\FoxitReader95_L10N_Setup_Prom.exe" /silent
:: Foobar2000
if not exist "foobar2000_v1.4.5.exe" wget.exe --no-check-certificate --tries=3 -c "http://foobar2000.org/files/b9762912dd1331e7f240976016385176/foobar2000_v1.4.5.exe"
"%setupbin%\foobar2000_v1.4.5.exe" /S
:: WinDirStat
if not exist "wds_current_setup.exe" wget.exe --no-check-certificate --tries=3 -c "http://windirstat.net/wds_current_setup.exe"
"%setupbin%\wds_current_setup.exe" /S
del /f /q "%userprofile%\desktop\WinDirStat.lnk"
:: HWMonitor
if not exist "hwmonitor_1.40.exe" wget.exe --no-check-certificate --tries=3 -c "http://download.cpuid.com/hwmonitor/hwmonitor_1.40.exe"
"%setupbin%\hwmonitor_1.40.exe" /VERYSILENT
del /f /q "%public%\desktop\CPUID HWMonitor.lnk"
:: Keyboard LEDs
if not exist "keyboard-leds.exe" wget.exe --no-check-certificate --tries=3 -c "http://keyboard-leds.com/files/keyboard-leds.exe"
"%setupbin%\keyboard-leds.exe" /S
del /f /q "%public%\desktop\Keyboard LEDs.lnk"
:: DotnetFX 3.5
::dism /online /enable-feature /featurename:NetFx3 /All /Source:X:\sources\sxs /LimitAccess
if not exist "dotnetfx35.exe" wget.exe --no-check-certificate --tries=3 -c "http://download.microsoft.com/download/2/0/e/20e90413-712f-438c-988e-fdaa79a8ac3d/dotnetfx35.exe"
"%setupbin%\dotnetfx35.exe" /s
:: Classic Shell
if not exist "ClassicShellSetup_4_3_1-ru.exe" wget.exe --no-check-certificate --tries=3 -c http://classicshell.mediafire.com/file/ckuf8e75ar0oixy/ClassicShellSetup_4_3_1-ru.exe
if "%ntver%" neq "6.1" ClassicShellSetup_4_3_1-ru.exe /quiet
:: Tango Patcher
if not exist "WinTango-Patcher-16.12.24-offline.exe" wget.exe --no-check-certificate --tries=3 -c "http://github.com/heebijeebi/WinTango-Patcher/releases/download/v16.12.24/WinTango-Patcher-16.12.24-offline.exe"
"%setupbin%\WinTango-Patcher-16.12.24-offline.exe" /S
::
:eof
color 02 &echo Installation completed. &pause
::