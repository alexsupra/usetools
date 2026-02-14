:: fastguitweak.cmd - Making Windows GUI shell fast and smart
:: for 32/64-bits OS Windows NT 6.1, 6.2, 6.3, 10.0
:: https://github.com/alexsupra/usetools
@echo off &cls
set fastguitweak_version=2602.05
chcp 866 >nul
if "%1"=="-s" goto os_check
net session >nul 2>&1
if %errorLevel% neq 0 title title %~nx0&echo Administrative permissions check failure!!&echo RESTART AS ADMINISTRATOR&color 0e &pause &exit
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
echo     ³ fastguitweak.cmd - making Windows GUI shell fast and smart v%fastguitweak_version% ³
echo     ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cd /d "%~dp0"
set sysinstall=%cd%
set setupbin=%cd%\setupbin
set setupcfg=%cd%\setupcfg
set path=%path%;%sysinstall%;%setupbin%
if "%ntver%"=="10.0" goto menu_win10
:menu
echo. &echo [1] Apply system registry tweaks, install Open-Shell
echo [2] Apply system registry tweaks
echo [3] Apply system registry tweaks, install Open-Shell, OldNewExplorer, SecureUxTheme
echo [4] Apply system registry tweaks, install Open-Shell, OldNewExplorer, SecureUxTheme, TangoPatcher
echo [0] Reboot
echo [x] Exit &echo.
set userinput=
set /p userinput=Input your choice and press enter [1/2/3/4/0/x]:
if "%userinput%"=="" goto menu
if %userinput%==0 exit
if %userinput%==1 goto regtweaks
if %userinput%==2 goto regtweaks
if %userinput%==3 goto regtweaks
if %userinput%==4 goto regtweaks
if %userinput%==0 shutdown /r /t 0
if %userinput%==x exit
echo. &echo Input seems to be incorrect. Please try one more time
goto menu
::
:menu_win10
echo. &echo [1;104m[1][0m [50;96mApply system registry tweaks, install Open-Shell[0m
echo [1;104m[2][0m [50;96mApply system registry tweaks[0m
echo [1;104m[3][0m [50;96mApply system registry tweaks, install Open-Shell, OldNewExplorer, SecureUxTheme[0m
echo [1;104m[4][0m [50;96mApply system registry tweaks, install Open-Shell, OldNewExplorer, SecureUxTheme, TangoPatcher[0m
echo [1;104m[0][0m [50;96mReboot[0m
echo [1;104m[x][0m [50;96mExit &echo.[0m
set userinput=
set /p userinput=[50;96mInput your choice and press enter[0m [1;104m[1/2/3/0/x][0m:
if "%userinput%"=="" goto menu_win10
if %userinput%==1 goto regtweaks
if %userinput%==2 goto regtweaks
if %userinput%==3 goto regtweaks
if %userinput%==4 goto regtweaks
if %userinput%==0 shutdown /r /t 0
if %userinput%==x exit
echo. &echo [40;93mInput seems to be incorrect. Please try one more time[0m
goto menu_win10
::
:regtweaks
echo. &echo Creating system registry backup ...
set backup=%sysinstall%\backup
if not exist "%backup%" md "%backup%
reg export "hkey_local_machine" "%backup%\hklm_%computername%_%date%.reg" /y
reg export "hkey_current_user" "%backup%\hkcu_%computername%_%username%_%date%.reg" /y
echo. &echo Applying system registry settings ...
:: run Explorer windows as separate processes
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SeparateProcess" /t reg_dword /d "1" /f
:: show file extensions
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t reg_dword /d "0" /f
:: show hidden files
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t reg_dword /d "1" /f
:: disable taskbar animations
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t reg_dword /d "0" /f
:: taskbar small icons
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarSmallIcons" /t reg_dword /d "1" /f
:: show status bar in Explorer
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TShowStatusBar" /t reg_dword /d "1" /f
:: open pc instead of libs in Explorer
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t reg_dword /d "1" /f
:: show all folders in Explorer
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "NavPaneShowAllFolders" /t reg_dword /d "1" /f
:: show run in Start menu
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_ShowRun" /t reg_dword /d "1" /f
:: show folder merge conflicts
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideMergeConflicts" /t reg_dword /d "0" /f
:: hide task view button on taskbar
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowTaskViewButton" /t reg_dword /d "0" /f
:: hide action center tray icon
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAHealth" /t reg_dword /d "1" /f
:: grey out not fully installed apps
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "GreyMSIAds" /t reg_dword /d "1" /f
:: classic control panel
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "ForceClassicControlPanel" /t reg_dword /d "1" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "AllItemsIconView" /t reg_dword /d "1" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "StartupPage" /t reg_dword /d "1" /f
:: fast menus
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v "MenuShowDelay" /t reg_sz /d "0" /f
:: font smoothing
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v "FontSmoothing" /t reg_sz /d "2" /f
:: disable windows animations
reg add "HKEY_CURRENT_USER\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t reg_sz /d "0" /f
:: visual effects settings
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v "UserPreferencesMask" /t reg_binary /d "9C12078010000000" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t reg_dword /d "3" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\AnimateMinMax" /v "DefaultApplied" /t reg_dword /d "0" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\AnimateMinMax" /v "DefaultValue" /t reg_dword /d "0" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\AnimateMinMax" /v "DefaultByAlphaTest" /t reg_dword /d "0" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\ComboBoxAnimation" /v "DefaultApplied" /t reg_dword /d "0" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\ComboBoxAnimation" /v "DefaultValue" /t reg_dword /d "0" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\ComboBoxAnimation" /v "DefaultByAlphaTest" /t reg_dword /d "0" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\ControlAnimations" /v "DefaultApplied" /t reg_dword /d "0" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\ControlAnimations" /v "DefaultValue" /t reg_dword /d "0" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\ControlAnimations" /v "DefaultByAlphaTest" /t reg_dword /d "0" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\FontSmoothing" /v "DefaultApplied" /t reg_dword /d "1" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\FontSmoothing" /v "DefaultValue" /t reg_dword /d "1" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\FontSmoothing" /v "DefaultByAlphaTest" /t reg_dword /d "1" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\MenuAnimation" /v "DefaultApplied" /t reg_dword /d "0" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\MenuAnimation" /v "DefaultValue" /t reg_dword /d "0" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\MenuAnimation" /v "DefaultByAlphaTest" /t reg_dword /d "0" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\TaskbarAnimations" /v "DefaultApplied" /t reg_dword /d "0" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\TaskbarAnimations" /v "DefaultValue" /t reg_dword /d "0" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\TaskbarAnimations" /v "DefaultByAlphaTest" /t reg_dword /d "0" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\TooltipAnimation" /v "DefaultApplied" /t reg_dword /d "0" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\TooltipAnimation" /v "DefaultValue" /t reg_dword /d "0" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\TooltipAnimation" /v "DefaultByAlphaTest" /t reg_dword /d "0" /f
:: show pc shortcut on desktop
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t reg_dword /d "0" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t reg_dword /d "0" /f
::
:: classic rclick menu
reg add "HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f
:: set taskbar alignment (0,1,2)
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAl" /t reg_dword /d "0" /f
::
:: no Store apps on taskbar
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "StoreAppsOnTaskbar" /t reg_dword /d "0" /f
:: no pinning Store to taskbar
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoPinningStoreToTaskbar" /t reg_dword /d "1" /f
:: list desktop apps first
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartPage" /v "DesktopFirst" /t reg_dword /d "1" /f
:: disable live tiles notifications
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartPage" /v "NoTileApplicationNotification" /t reg_dword /d "1" /f
:: disable ads in explorer
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartPage" /v "ShowSyncProviderNotifications" /t reg_dword /d "0" /f
::
:: disable first logon animations
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "EnableFirstLogonAnimation" /t reg_dword /d "0" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableFirstLogonAnimation" /t reg_dword /d "0" /f
:: hide 3d objects folder
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" /v "ThisPCPolicy" /t reg_sz /d "Hide" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" /f
::
if %userinput%==2 goto completed
::
if not exist "%sysinstall%\wget.exe" (
	echo [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls" >getwget.ps1
	echo Invoke-WebRequest 'http://eternallybored.org/misc/wget/1.21.4/32/wget.exe' -OutFile 'wget.exe' >>getwget.ps1
	powershell -ExecutionPolicy Bypass -File getwget.ps1
	if not exist "%sysinstall%\wget.exe" (
		echo. &echo Now we will start IE for downloading wget.exe, save it in the same dir with sysinstall.cmd and close browser window.&color 0e &pause
		"%programfiles%\internet explorer\iexplore.exe" "http://eternallybored.org/misc/wget/1.20.3/32/wget.exe"
		)
	del /f /q getwget.ps1 >nul
	)
if not exist "%setupbin%" md "%setupbin%"
cd "%setupbin%"
if %userinput%==1 goto openshell
if "%osarch%"=="x64" goto 7-zip64
::
:: 7-zip64
echo. &echo Installing 7-zip 64-bit ...
tasklist /fi "imagename eq 7zfm.exe" |find ":" >nul
if errorlevel 1 taskkill /f /im "7zfm.exe"
if not exist "%setupbin%\7z2600.msi" wget.exe --tries=3 --no-check-certificate -c "http://www.7-zip.org/a/7z2600.msi"
msiexec /package "%setupbin%\7z2600.msi" /quiet /norestart
if not exist "%setupbin%\7z2600-extra.7z" wget.exe --tries=3 --no-check-certificate -c "http://www.7-zip.org/a/7z2600-extra.7z"
"%ProgramFiles%\7-Zip\7zg.exe" x -r -y -o"%ProgramFiles%\7-Zip" "%setupbin%\7z2501-extra.7z"
if not exist "%sysinstall%"\7za.exe copy /y "%ProgramFiles%\7-Zip\7za.exe" "%sysinstall%"
copy /y "%ProgramFiles%\7-Zip\7za.exe" "%systemroot%\system32"
::
:: NirCMD32
echo Installing NirCMD ...
if not exist "%setupbin%\nircmd.zip" wget.exe --tries=3 --no-check-certificate -c "http://www.nirsoft.net/utils/nircmd.zip" -O "%setupbin%\nircmd.zip"
7za.exe x -r -y -x!*.chm -o"%sysinstall%" "%setupbin%\nircmd.zip"
copy /y "%sysinstall%\nircmd.exe" "%systemroot%\system32"
copy /y "%sysinstall%\nircmdc.exe" "%systemroot%\system32"
::
:7-zip64
:: 7-zip64
echo. &echo Installing 7-zip 64-bit ...
tasklist /fi "imagename eq 7zfm.exe" |find ":" >nul
if errorlevel 1 taskkill /f /im "7zfm.exe"
if not exist "%setupbin%\7z2600-x64.msi" wget.exe --tries=3 --no-check-certificate -c "http://www.7-zip.org/a/7z2600-x64.msi"
msiexec /package "%setupbin%\7z2600-x64.msi" /quiet /norestart
if not exist "%setupbin%\7z2600-extra.7z" wget.exe --tries=3 --no-check-certificate -c "http://www.7-zip.org/a/7z2600-extra.7z"
if exist "%ProgramFiles%\7-Zip" set sevenzip=%ProgramFiles%\7-Zip
if not exist "%ProgramFiles%\7-Zip" set sevenzip=%ProgramFiles(x86)%\7-Zip
"%sevenzip%\7zg.exe" x -r -y -o"%sevenzip%" "%setupbin%\7z2501-extra.7z"
if not exist "%sysinstall%\7za.exe" copy /y "%sevenzip%\x64\7za.exe" "%sysinstall%"
copy /y "%sevenzip%\x64\7za.exe" "%systemroot%\system32"
::
:: NirCMD64
echo Installing NirCMD ...
if not exist "%setupbin%\nircmd-x64.zip" wget.exe --tries=3 --no-check-certificate -c "http://www.nirsoft.net/utils/nircmd-x64.zip" -O "%setupbin%\nircmd-x64.zip"
if not exist "%sysinstall%\nircmdc.exe" 7za.exe x -r -y -x!*.chm -o"%sysinstall%" "%setupbin%\nircmd-x64.zip"
copy /y "%sysinstall%\nircmd.exe" "%systemroot%\system32"
copy /y "%sysinstall%\nircmdc.exe" "%systemroot%\system32"
::
:: Open-Shell
:openshell
echo. &echo Installing Open-Shell ...
if not exist "%setupbin%\OpenShellSetup_4_4_196.exe" wget.exe --tries=3 --no-check-certificate -c "http://github.com/Open-Shell/Open-Shell-Menu/releases/download/v4.4.196/OpenShellSetup_4_4_196.exe"
"%setupbin%\OpenShellSetup_4_4_196.exe" /quiet
if %osarch%==x86 regsvr32 /u /s "%programfiles%\open-shell\classicexplorer32.dll"
if %osarch%==x64 %systemroot%\syswow64\regsvr32.exe /u /s "%programfiles%\open-shell\classicexplorer64.dll"
if %userinput%==1 goto completed
::
:: OldNewExplorer
:oldnewexplorer
echo. &echo Installing OldNewExplorer ...
if not exist "%setupbin%\oldnewexplorer.zip" wget.exe --tries=3 --no-check-certificate -c "http://www.oldnewexplorer.com/dl/OldNewExplorer.zip"
if not exist "%setupcfg%" md "%setupcfg%"
cd "%setupcfg%"
if not exist "%setupcfg%\oldnewexplorer.7z" wget.exe --tries=3 --no-check-certificate -c "http://github.com/alexsupra/usetools/raw/refs/heads/master/setupcfg/oldnewexplorer.7z"
7za.exe x -r -y -o"%programfiles%" "%setupbin%\oldnewexplorer.zip"
7za.exe x -r -y -o"%programfiles%" "%setupcfg%\oldnewexplorer.7z"
if %osarch%==x86 regsvr32 /s "%programfiles%\oldnewexplorer\oldnewexplorer32.dll"
if %osarch%==x64 %systemroot%\syswow64\regsvr32.exe /s "%programfiles%\oldnewexplorer\oldnewexplorer32.dll"
regedit /s "%programfiles%\oldnewexplorer\oldnewexplorer.reg"

cd "%setupbin%"
::
:: SecureUxTheme
:secureuxtheme
echo. &echo Installing SecureUxTheme ...
if not exist "%setupbin%\SecureUxTheme_%osarch%.msi" wget.exe --tries=3 --no-check-certificate -c "https://github.com/namazso/SecureUxTheme/releases/download/v4.0.0/SecureUxTheme_%osarch%.msi"
msiexec /package "%setupbin%\SecureUxTheme_%osarch%.msi" /quiet /norestart
if %userinput%==3 goto completed
::
:dotnetfx
:: DotnetFX
echo. &echo Installing DotnetFX ...
if "%ntver%" neq "6.1" goto dotnetfx_win81
if not exist "%setupbin%\dotnetfx35.exe" wget.exe --tries=3 --no-check-certificate -c "http://download.microsoft.com/download/2/0/e/20e90413-712f-438c-988e-fdaa79a8ac3d/dotnetfx35.exe"
"%setupbin%\dotnetfx35.exe" /s
goto tangopatcher
:dotnetfx_win81
DISM /Online /Enable-Feature /FeatureName:NetFx3 /All
::
:: Tango Patcher
:tangopatcher
echo. &echo Installing Windows Tango Patcher ...
if not exist "%setupbin%\WinTango-Patcher-24.08.02-offline.exe" wget.exe --tries=3 --no-check-certificate -c "http://github.com/alexsupra/WinTango-Patcher/releases/download/v24.08.02/WinTango-Patcher-24.08.02-offline.exe"
nircmdc.exe initshutdown "sysinstall.cmd: system will be restarted automatically in a 3 min." 180 force reboot
"%setupbin%\WinTango-Patcher-24.08.02-offline.exe" /S
::
:completed
if exist "%sysinstall%\nircmd.exe" (
	echo. &echo Restarting GUI shell ...
	nircmd.exe restartexplorer
	)
title %~nx0 - installation is completed
if "%ntver%"=="10.0" echo [30;102mPRESS ANY KEY TO EXIT[0m
if "%ntver%" neq "10.0" (
	echo PRESS ANY KEY TO EXIT
	color 0a
	)
pause >nul
exit
::
