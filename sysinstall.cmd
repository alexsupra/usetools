:: sysinstall.cmd - software and settings installation script providing better defaults
:: for 32/64-bits OS Windows NT 6.1, 6.2, 6.3, 10.0
:: https://github.com/alexsupra/usetools
@echo off &cls
::setlocal enabledelayedexpansion
chcp 866 >nul
if "%1"=="-s" goto os_check
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
set sysinstall_version=2312.02
echo     ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
echo     ÛÛ    ÛÛ ÛÛßßßßÛÛ ÛßßßßßßÛ ßßßÛÛßßß ÛßßßßßßÛ ÛßßßßßßÛ ÛÛ       ÛÛßßßßÛÛ 
echo     ÛÛ    ÛÛ ÛÛ       Û           ÛÛ    Û      Û Û      Û ÛÛ       ÛÛ       
echo     ÛÛ    ÛÛ  ßßßßßßÛ Ûßßßßß      ÛÛ    Û      Û Û      Û ÛÛ        ßßßßßßÛ  
echo     ÛÛ    ÛÛ ÛÛ     Û Û      Û    ÛÛ    Û      Û Û      Û ÛÛ    ÛÛ ÛÛ     Û 
echo      ßßßßßßß ßßßßßßßß ßßßßßßßß    ßß    ßßßßßßßß ßßßßßßßß ßßßßßßßß ßßßßßßßß  
echo     ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
echo     ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
echo     ³ sysinstall.cmd - software and settings installation script v%sysinstall_version% ³
echo     ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cd /d "%~dp0"
set sysinstall=%cd%
set setupbin=%cd%\setupbin
set setupcfg=%cd%\setupcfg
set backup=%cd%\backup
if "%1"=="-s" goto config
if "%1"=="-u" (
	echo. &echo Running in unattended mode ...
	set userinput=1
	goto prepair
	)
::
:menu
echo. &echo [1] Install system settings and software apps
echo [2] Install system settings
echo [3] Install software apps
echo [4] Make system registry backup
echo [5] Restore system from registry backup
echo [9] Reboot
echo [0] Exit &echo.
set userinput=0
set /p userinput=Input your choice and press enter [1/2/3/4/5/9/0]:
if %userinput%==0 exit
if %userinput%==1 goto prepair
if %userinput%==2 goto config
if %userinput%==3 goto prepair
if %userinput%==4 goto backup
if %userinput%==5 goto restore
if %userinput%==9 goto reboot
echo Input seems to be incorrect. Please try one more time
goto menu
::
:backup
echo. &echo Making system registry backup ...&echo.
if not exist "%backup%" md "%backup%"
reg export "hkey_local_machine" "%backup%\hklm.reg"
reg export "hkey_classes_root" "%backup%\hkcr.reg"
reg export "hkey_current_user" "%backup%\hkcu.reg"
reg export "hkey_users\.default" "%backup%\hkud.reg"
if %userinput%==4 goto menu
::
:restore
echo. &echo Restoring system from registry backup ...&echo.
if not exist "%backup%" echo Backup not found &goto menu
if exist "%backup%\hklm.reg" regedit /s "%backup%\hklm.reg"
if exist "%backup%\hkcr.reg" regedit /s "%backup%\hkcr.reg"
if exist "%backup%\hkcu.reg" regedit /s "%backup%\hkcu.reg"
if exist "%backup%\hkud.reg" regedit /s "%backup%\hkud.reg"
if %userinput%==5 goto menu
::
:prepair
:: Wget
if not exist "%sysinstall%\wget.exe" (
	echo [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls" >getwget.ps1
	echo Invoke-WebRequest 'http://eternallybored.org/misc/wget/1.20.3/32/wget.exe' -OutFile 'wget.exe' >>getwget.ps1
	powershell -ExecutionPolicy Bypass -File getwget.ps1
	if not exist "%sysinstall%\wget.exe" (
		echo. &echo Now we will start IE for downloading wget.exe, save it in the same dir with sysinstall.cmd and close browser window.&color 0e &pause
		"%programfiles%\internet explorer\iexplore.exe" "http://eternallybored.org/misc/wget/1.20.3/32/wget.exe"
		)
	del /f /q getwget.ps1 >nul
	goto prepair
	)
copy /y "%sysinstall%\wget.exe" %systemroot%\system32
if not exist "%setupbin%" md "%setupbin%"
if not exist "%setupcfg%" md "%setupcfg%"
set path=%path%;%sysinstall%;%setupbin%
for /f "tokens=2*" %%a in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\MICROSOFT\WINDOWS NT\CurrentVersion\ProfileList" /v "Default"') do call set "defaultuserprofile=%%b"
if %userinput%==3 goto install
::
:config
if "%1"=="-s" goto config_user
:: System and user configuration settings for Windows NT 6.1, 6.2, 6.3, 10.0
:config_system
echo. &echo Applying general SYSTEM settings ...&echo.
:: SYSTEM
:: end hung tasks automatically
reg add "HKEY_USERS\.DEFAULT\Control Panel\Desktop" /v "AutoEndTasks" /t reg_sz /d "1" /f
:: run Explorer windows as separate processes
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SeparateProcess" /t reg_dword /d "1" /f
:: optimize system perfomance
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t reg_dword /d "1" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t reg_dword /d "1" /f
:: keyboard layout settings
reg add "HKEY_USERS\.DEFAULT\keyboard layout\preload" /v "1" /t reg_sz /d "00000409" /f
reg add "HKEY_USERS\.DEFAULT\keyboard layout\preload" /v "2" /t reg_sz /d "00000419" /f
reg add "HKEY_USERS\.DEFAULT\keyboard layout\toggle" /v "hotkey" /t reg_sz /d "2" /f
:: GUI/SHELL
:: remove "is shortcut" text
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "link" /t reg_binary /d "000000000000" /f
:: show file extensions
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t reg_dword /d "0" /f
:: show hidden files
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t reg_dword /d "1" /f
:: disable taskbar animations
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t reg_dword /d "0" /f
:: taskbar small icons
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarSmallIcons" /t reg_dword /d "1" /f
:: show status bar in Explorer
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TShowStatusBar" /t reg_dword /d "1" /f
:: open pc instead of libs in Explorer
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t reg_dword /d "1" /f
:: show all folders in Explorer
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "NavPaneShowAllFolders" /t reg_dword /d "1" /f
:: show run in Start menu
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_ShowRun" /t reg_dword /d "1" /f
:: show folder merge conflicts
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideMergeConflicts" /t reg_dword /d "0" /f
:: hide task view button on taskbar
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowTaskViewButton" /t reg_dword /d "0" /f
:: hide action center tray icon
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAHealth" /t reg_dword /d "1" /f
:: grey out not fully installed apps
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "GreyMSIAds" /t reg_dword /d "1" /f
:: classic control panel
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "ForceClassicControlPanel" /t reg_dword /d "1" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "AllItemsIconView" /t reg_dword /d "1" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "StartupPage" /t reg_dword /d "1" /f
:: fast menus
reg add "HKEY_USERS\.DEFAULT\Control Panel\Desktop" /v "MenuShowDelay" /t reg_sz /d "0" /f
:: font smoothing
reg add "HKEY_USERS\.DEFAULT\Control Panel\Desktop" /v "FontSmoothing" /t reg_sz /d "2" /f
:: disable windows animations
reg add "HKEY_USERS\.DEFAULT\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t reg_sz /d "0" /f
:: visual effects settings
reg add "HKEY_USERS\.DEFAULT\Control Panel\Desktop" /v "UserPreferencesMask" /t reg_binary /d "9C12078010000000" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t reg_dword /d "3" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\AnimateMinMax" /v "DefaultApplied" /t reg_dword /d "0" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\AnimateMinMax" /v "DefaultValue" /t reg_dword /d "0" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\AnimateMinMax" /v "DefaultByAlphaTest" /t reg_dword /d "0" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\ComboBoxAnimation" /v "DefaultApplied" /t reg_dword /d "0" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\ComboBoxAnimation" /v "DefaultValue" /t reg_dword /d "0" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\ComboBoxAnimation" /v "DefaultByAlphaTest" /t reg_dword /d "0" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\ControlAnimations" /v "DefaultApplied" /t reg_dword /d "0" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\ControlAnimations" /v "DefaultValue" /t reg_dword /d "0" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\ControlAnimations" /v "DefaultByAlphaTest" /t reg_dword /d "0" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\FontSmoothing" /v "DefaultApplied" /t reg_dword /d "1" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\FontSmoothing" /v "DefaultValue" /t reg_dword /d "1" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\FontSmoothing" /v "DefaultByAlphaTest" /t reg_dword /d "1" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\MenuAnimation" /v "DefaultApplied" /t reg_dword /d "0" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\MenuAnimation" /v "DefaultValue" /t reg_dword /d "0" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\MenuAnimation" /v "DefaultByAlphaTest" /t reg_dword /d "0" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\TaskbarAnimations" /v "DefaultApplied" /t reg_dword /d "0" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\TaskbarAnimations" /v "DefaultValue" /t reg_dword /d "0" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\TaskbarAnimations" /v "DefaultByAlphaTest" /t reg_dword /d "0" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\TooltipAnimation" /v "DefaultApplied" /t reg_dword /d "0" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\TooltipAnimation" /v "DefaultValue" /t reg_dword /d "0" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\TooltipAnimation" /v "DefaultByAlphaTest" /t reg_dword /d "0" /f
:: show pc shortcut on desktop
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t reg_dword /d "0" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t reg_dword /d "0" /f
:: register/unregister dll from shell menu
reg add "HKEY_CLASSES_ROOT\dllfile\shell\Register\command" /v "" /t reg_sz /d "regsvr32.exe \"%%L\"" /f
reg add "HKEY_CLASSES_ROOT\dllfile\shell\Unregister\command" /v "" /t reg_sz /d "regsvr32.exe /u \"%%L\"" /f
:: register/unregister ocx from shell menu
reg add "HKEY_CLASSES_ROOT\ocxfile\shell\Register\command" /v "" /t reg_sz /d "regsvr32.exe \"%%L\"" /f
reg add "HKEY_CLASSES_ROOT\ocxfile\shell\Unregister\command" /v "" /t reg_sz /d "regsvr32.exe /u \"%%L\"" /f
:: CMD
:: run cmd.exe as administrator from shell menu
reg add "HKEY_CLASSES_ROOT\Directory\shell\runas" /v "" /t reg_sz /d "CMD" /f
reg add "HKEY_CLASSES_ROOT\Directory\shell\runas" /v "HasLUAShield" /t reg_sz /d "" /f
reg add "HKEY_CLASSES_ROOT\Directory\shell\runas" /v "Icon" /t reg_expand_sz /d "cmd.exe,0" /f
reg add "HKEY_CLASSES_ROOT\Directory\shell\runas\command" /v "" /t reg_sz /d "cmd.exe /s /k pushd \"%%V\"" /f
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\runas" /v "" /t reg_sz /d "CMD" /f
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\runas" /v "HasLUAShield" /t reg_sz /d "" /f
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\runas" /v "Icon" /t reg_expand_sz /d "cmd.exe,0" /f
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\runas\command" /v "" /t reg_sz /d "cmd.exe /s /k pushd \"%%V\"" /f
reg add "HKEY_CLASSES_ROOT\Drive\shell\runas" /v "" /t reg_sz /d "CMD" /f
reg add "HKEY_CLASSES_ROOT\Drive\shell\runas" /v "HasLUAShield" /t reg_sz /d "" /f
reg add "HKEY_CLASSES_ROOT\Drive\shell\runas" /v "Icon" /t reg_expand_sz /d "cmd.exe,0" /f
reg add "HKEY_CLASSES_ROOT\Drive\shell\runas\command" /v "" /t reg_sz /d "cmd.exe /s /k pushd \"%%V\"" /f
:: create new cmd file from shell menu
reg add "HKEY_CLASSES_ROOT\.cmd\ShellNew" /v "FileName" /t reg_sz /d "template.cmd" /f
:: NETWORKING
:: avoid CredSSP encryption oracle problem
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\CredSSP\Parameters" /v "AllowEncryptionOracle" /t reg_dword /d "0x00000002" /f
:: APPS
:: Edge
reg add "HKEY_CLASSES_ROOT\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main" /v "HomeButtonEnabled" /t reg_dword /d "1" /f
reg add "HKEY_CLASSES_ROOT\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main" /v "HomeButtonPage" /t reg_sz /d "http://www.google.com" /f
:: DISABLED COMPONENTS AND FIXES
:: disable automatic updates
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v "AUOptions" /t reg_dword /d "1" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /t reg_dword /d "1" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t reg_dword /d "1" /f
:: disable error reporting
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t reg_dword /d "1" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "DoNotSendAdditionalData" /t reg_dword /d "1" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "LoggingDisabled" /t reg_dword /d "1" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t reg_dword /d "1" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "DoNotSendAdditionalData" /t reg_dword /d "1" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "LoggingDisabled" /t reg_dword /d "1" /f
:: disable remote registry service
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\RemoteRegistry" /v "Start" /t reg_dword /d "0x00000004" /f
:: disable offline files service
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\CscService" /v "Start" /t reg_dword /d "0x00000004" /f
::
:config_user
echo. &echo Applying general USER settings ...&echo.
:: USER
:: end hung tasks automatically
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v "AutoEndTasks" /t reg_sz /d "1" /f
:: run Explorer windows as separate processes
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SeparateProcess" /t reg_dword /d "1" /f
:: optimize system perfomance
reg add "HKEY_CURRENT_USER\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t reg_dword /d "1" /f
:: keyboard layout settings
reg add "HKEY_CURRENT_USER\keyboard layout\preload" /v "1" /t reg_sz /d "00000409" /f
reg add "HKEY_CURRENT_USER\keyboard layout\preload" /v "2" /t reg_sz /d "00000419" /f
reg add "HKEY_CURRENT_USER\keyboard layout\toggle" /v "hotkey" /t reg_sz /d "2" /f
:: GUI/SHELL
:: remove "is shortcut" text
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "link" /t reg_binary /d "000000000000" /f
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
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t reg_dword /d "0" /f
:: CMD
:: console settings
reg add "HKEY_CURRENT_USER\Console" /v "FaceName" /t reg_sz /d "Consolas" /f
reg add "HKEY_CURRENT_USER\Console" /v "FontSize" /t reg_dword /d "0x00140000" /f
reg add "HKEY_CURRENT_USER\Console" /v "FontFamily" /t reg_dword /d "0x00000036" /f
reg add "HKEY_CURRENT_USER\Console" /v "FontWeight" /t reg_dword /d "0x00000190" /f
reg add "HKEY_CURRENT_USER\Console" /v "ColorTable00" /t reg_dword /d "0" /f
reg add "HKEY_CURRENT_USER\Console" /v "ColorTable01" /t reg_dword /d "0x0064321e" /f
reg add "HKEY_CURRENT_USER\Console" /v "ColorTable02" /t reg_dword /d "0x00009b65" /f
reg add "HKEY_CURRENT_USER\Console" /v "ColorTable03" /t reg_dword /d "0x00af8723" /f
reg add "HKEY_CURRENT_USER\Console" /v "ColorTable04" /t reg_dword /d "0x002929ef" /f
reg add "HKEY_CURRENT_USER\Console" /v "ColorTable05" /t reg_dword /d "0x00e22b8a" /f
reg add "HKEY_CURRENT_USER\Console" /v "ColorTable06" /t reg_dword /d "0x000079f5" /f
reg add "HKEY_CURRENT_USER\Console" /v "ColorTable07" /t reg_dword /d "0x00ada7a7" /f
reg add "HKEY_CURRENT_USER\Console" /v "ColorTable08" /t reg_dword /d "0x00877676" /f
reg add "HKEY_CURRENT_USER\Console" /v "ColorTable09" /t reg_dword /d "0x00d26432" /f
reg add "HKEY_CURRENT_USER\Console" /v "ColorTable10" /t reg_dword /d "0x0032ff16" /f
reg add "HKEY_CURRENT_USER\Console" /v "ColorTable11" /t reg_dword /d "0x00fcac00" /f
reg add "HKEY_CURRENT_USER\Console" /v "ColorTable12" /t reg_dword /d "0x000a5eff" /f
reg add "HKEY_CURRENT_USER\Console" /v "ColorTable13" /t reg_dword /d "0x00cc0093" /f
reg add "HKEY_CURRENT_USER\Console" /v "ColorTable14" /t reg_dword /d "0x004fe9fc" /f
reg add "HKEY_CURRENT_USER\Console" /v "ColorTable15" /t reg_dword /d "0x00fdfaf7" /f
:: APPS
:: Internet Explorer
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Internet Explorer\Main" /v "Start Page" /t reg_sz /d "http://www.google.com" /f
::
if "%ntver%"=="6.2" goto config_system_win8x
if "%ntver%"=="6.3" goto config_system_win8x
if "%ntver%"=="10.0" goto config_system_win10
if "%1"=="-s" goto setup
if %userinput%==2 goto menu
goto install
::
:: System and user configuration settings for Windows NT 6.2, 6.3
:config_system_win8x
if "%1"=="-s" goto config_user_win8x
echo. &echo Applying Windows 8.X SYSTEM settings ...&echo.
:: SYSTEM
:: disable startup delay
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v "StartupDelayInMSec" /t reg_dword /d "0" /f
:: GUI/SHELL
:: disable charms bar
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell\EdgeUi" /v "DisableCharmsHint" /t reg_dword /d "1" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell\EdgeUi" /v "DisableTLCorner" /t reg_dword /d "1" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell\EdgeUi" /v "DisableTRCorner" /t reg_dword /d "1" /f
:: DISABLED COMPONENTS AND FIXES
:: disable Windows Store feature
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsStore" /v "RemoveWindowsStore" /t reg_dword /d "1" /f
:: disable auto download and update of Store apps
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsStore" /v "AutoDownload" /t reg_dword /d "0x00000004" /f
:: remove look for an app in Store
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "NoUseStoreOpenWith" /t reg_dword /d "1" /f
:: no Store apps on taskbar
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "StoreAppsOnTaskbar" /t reg_dword /d "0" /f
:: no pinning Store to taskbar
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoPinningStoreToTaskbar" /t reg_dword /d "1" /f
:: list desktop apps first
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartPage" /v "DesktopFirst" /t reg_dword /d "1" /f
:: show apps view automatically
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartPage" /v "MakeAllAppsDefault" /t reg_dword /d "1" /f
:: disable live tiles notifications
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartPage" /v "NoTileApplicationNotification" /t reg_dword /d "1" /f
::
:config_user_win8x
echo. &echo Applying Windows 8.X USER settings ...&echo.
:: USER
:: disable startup delay
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v "StartupDelayInMSec" /t reg_dword /d "0" /f
:: GUI/SHELL
:: disable charms bar
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell\EdgeUi" /v "DisableCharmsHint" /t reg_dword /d "1" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell\EdgeUi" /v "DisableTLCorner" /t reg_dword /d "1" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell\EdgeUi" /v "DisableTRCorner" /t reg_dword /d "1" /f
:: disable Metro tips
reg add "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\EdgeUI" /v "DisableHelpSticker" /t reg_dword /d "1" /f
:: go to the desktop instead of start
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartPage" /v "OpenAtLogon" /t reg_dword /d "0" /f
:: show my desktop background on start
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent" /v "MotionAccentId_v1.00" /t reg_dword /d "0x000000db" /f
:: DISABLED COMPONENTS AND FIXES
:: remove look for an app in Store
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "NoUseStoreOpenWith" /t reg_dword /d "1" /f
:: no Store apps on taskbar
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "StoreAppsOnTaskbar" /t reg_dword /d "0" /f
:: no pinning Store to taskbar
reg add "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoPinningStoreToTaskbar" /t reg_dword /d "1" /f
:: list desktop apps first
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartPage" /v "DesktopFirst" /t reg_dword /d "1" /f
:: show apps view automatically
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartPage" /v "MakeAllAppsDefault" /t reg_dword /d "1" /f
:: disable live tiles notifications
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartPage" /v "NoTileApplicationNotification" /t reg_dword /d "1" /f
:: set transparent taskbar
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "UseOLEDTaskbarTransparency" /t reg_dword /d "1" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t reg_dword /d "1" /f
:: thin windows borders width
reg add "HKEY_CURRENT_USER\Control Panel\Desktop\WindowMetrics" /v "BorderWidth" /t reg_sz /d "1" /f
reg add "HKEY_CURRENT_USER\Control Panel\Desktop\WindowMetrics" /v "PaddedBorderWidth" /t reg_sz /d "1" /f
if "%1"=="-s" goto setup
if %userinput%==2 goto menu
goto install
::
:: System and user configuration settings for Windows NT 10.0
:config_system_win10

if "%ntname%"=="Windows 11" goto config_system_win11
if "%1"=="-s" goto config_user_win10
echo. &echo Applying Windows 10 SYSTEM settings ...&echo.
:: SYSTEM
:: disable startup delay
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v "StartupDelayInMSec" /t reg_dword /d "0" /f
:: GUI/SHELL
:: disable first logon animations
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "EnableFirstLogonAnimation" /t reg_dword /d "0" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableFirstLogonAnimation" /t reg_dword /d "0" /f
:: hide 3d objects folder
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" /v "ThisPCPolicy" /t reg_sz /d "Hide" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" /v "ThisPCPolicy" /t reg_sz /d "Hide" /f
:: DISABLED COMPONENTS AND FIXES
:: disable OneDrive
reg add "HKEY_CLASSES_ROOT\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /t reg_dword /d "0" /f
reg add "HKEY_CLASSES_ROOT\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /t reg_dword /d "0" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSync" /t reg_dword /d "1" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSyncNGSC" /t reg_dword /d "1" /f
:: disable Windows Store feature
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsStore" /v "RemoveWindowsStore" /t reg_dword /d "1" /f
:: disable auto download and update of Store apps
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsStore" /v "AutoDownload" /t reg_dword /d "0x00000004" /f
:: remove look for an app in Store
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "NoUseStoreOpenWith" /t reg_dword /d "1" /f
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
:: disable Cortana but keep search and other search settings
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "PreventIndexOnBattery" /t reg_dword /d "1" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t reg_dword /d "0" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWeb" /t reg_dword /d "0" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableWebSearch" /t reg_dword /d "1" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "PreventIndexingOutlook" /t reg_dword /d "1" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "PreventIndexingEmailAttachments" /t reg_dword /d "1" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchPrivacy" /t reg_dword /d "0x00000003" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchSafeSearch" /t reg_dword /d "0x00000003" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "PreventRemoteQueries" /t reg_dword /d "1" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableRemovableDriveIndexing" /t reg_dword /d "1" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "BingSearchEnabled" /t reg_dword /d "0" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "CortanaConsent" /t reg_dword /d "0" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowSearchToUseLocation" /t reg_dword /d "0" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCloudSearch" /t reg_dword /d "0" /f
:: dont show advices
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableSoftLanding" /t reg_dword /d "1" /f
:: dont show recommendations
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t reg_dword /d "1" /f
:: dont show feedback notifications
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DoNotShowFeedbackNotifications" /t reg_dword /d "1" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "DoNotShowFeedbackNotifications" /t reg_dword /d "1" /f
:: disable telemetry
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DiagTrack" /v "Start" /t reg_dword /d "0x00000004" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t reg_dword /d "0" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowDeviceNameInTelemetry" /t reg_dword /d "0" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t reg_dword /d "0" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack\TestHooks" /v "Disabled" /t reg_dword /d "1" /f
:: remove "finish setting up your device" advertisment
reg add "HKEY_USERS\.DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v "ScoobeSystemSettingEnabled" /t reg_dword /d "0" /f
::
:config_user_win10
echo. &echo Applying Windows 10 USER settings ...&echo.
:: USER
:: disable startup delay
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v "StartupDelayInMSec" /t reg_dword /d "0" /f
:: GUI/SHELL
:: dont show people on taskbar
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" /v "PeopleBand" /t reg_dword /d "0" /f
:: disable search box on taskbar, but enable icon
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t reg_dword /d "1" /f
:: remove weather and news from taskbar
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds" /v "ShellFeedsTaskbarViewMode" /t reg_dword /d "2" /f
:: make the "open", "print", "edit" context menu items available when more than 15 files selected
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "MultipleInvokePromptMinimum" /t reg_dword /d "1" /f
:: DISABLED COMPONENTS AND FIXES
:: disable OneDrive
reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /f >nul 2>&1
:: remove look for an app in Store
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "NoUseStoreOpenWith" /t reg_dword /d "1" /f
:: no Store apps on taskbar
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "StoreAppsOnTaskbar" /t reg_dword /d "0" /f
:: no pinning Store to taskbar
reg add "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoPinningStoreToTaskbar" /t reg_dword /d "1" /f
:: list desktop apps first
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartPage" /v "DesktopFirst" /t reg_dword /d "1" /f
:: disable live tiles notifications
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartPage" /v "NoTileApplicationNotification" /t reg_dword /d "1" /f
:: disable ads in explorer
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartPage" /v "ShowSyncProviderNotifications" /t reg_dword /d "0" /f
:: turn off automatic installing suggested apps
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManage" /v "SilentInstalledAppsEnabled" /t reg_dword /d "0" /f
:: dont offer tailored experiences based on the diagnostics data setting
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" /v "TailoredExperiencesWithDiagnosticDataEnabled" /t reg_dword /d "0" /f
:: dont allow apps to use advertising id
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t reg_dword /d "0" /f
:: remove "finish setting up your device" advertisment
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v "ScoobeSystemSettingEnabled" /t reg_dword /d "0" /f
::
if "%1"=="-s" goto setup
if %userinput%==2 goto menu
goto install
::
:: System configuration settings for Windows NT 10.0 version 11
:config_system_win11
if "%1"=="-s" goto config_user_win11
echo. &echo Applying Windows 11 SYSTEM settings ...&echo.
:: SYSTEM
:: disable startup delay
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v "StartupDelayInMSec" /t reg_dword /d "0" /f
:: GUI/SHELL
:: disable first logon animations
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "EnableFirstLogonAnimation" /t reg_dword /d "0" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableFirstLogonAnimation" /t reg_dword /d "0" /f
:: hide 3d objects folder
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" /v "ThisPCPolicy" /t reg_sz /d "Hide" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" /v "ThisPCPolicy" /t reg_sz /d "Hide" /f
:: get classic taskbar
::reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell\Update\Packages" /v "UndockingDisabled" /t reg_dword /d "1" /f
:: DISABLED COMPONENTS AND FIXES
:: disable OneDrive
reg add "HKEY_CLASSES_ROOT\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /t reg_dword /d "0" /f
reg add "HKEY_CLASSES_ROOT\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /t reg_dword /d "0" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSync" /t reg_dword /d "1" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSyncNGSC" /t reg_dword /d "1" /f
:: dont show advices
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableSoftLanding" /t reg_dword /d "1" /f
:: dont show recommendations
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t reg_dword /d "1" /f
:: dont show feedback notifications
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DoNotShowFeedbackNotifications" /t reg_dword /d "1" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "DoNotShowFeedbackNotifications" /t reg_dword /d "1" /f
:: disable telemetry
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DiagTrack" /v "Start" /t reg_dword /d "0x00000004" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t reg_dword /d "0" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowDeviceNameInTelemetry" /t reg_dword /d "0" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t reg_dword /d "0" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack\TestHooks" /v "Disabled" /t reg_dword /d "1" /f
::
:: User configuration settings for Windows NT 10.0 version 11
:config_user_win11
echo. &echo Applying Windows 11 USER settings ...&echo.
:: GUI/SHELL
:: set taskbar size (0,1,2)
::reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarSi" /t reg_dword /d "1" /f
:: DISABLED COMPONENTS AND FIXES
:: disable OneDrive
reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /f >nul 2>&1
:: remove look for an app in Store
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "NoUseStoreOpenWith" /t reg_dword /d "1" /f
:: no Store apps on taskbar
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "StoreAppsOnTaskbar" /t reg_dword /d "0" /f
:: no pinning Store to taskbar
reg add "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoPinningStoreToTaskbar" /t reg_dword /d "1" /f
::
if "%1"=="-s" goto setup
if %userinput%==2 goto menu
::
:: Software apps
:install
color 0b
cd "%setupbin%"
if "%osarch%"=="x86" goto osx86
if "%osarch%"=="x64" goto osx64
::
:osx86
echo. &echo Running software APPS installation in 32-bit mode ...&echo.
:: 7-zip32
echo Installing 7-zip ...
tasklist /fi "imagename eq 7zfm.exe" |find ":" >nul
if errorlevel 1 taskkill /f /im "7zfm.exe"
if not exist "%setupbin%\7z1900.msi" wget.exe --tries=3 --no-check-certificate -c "http://netcologne.dl.sourceforge.net/project/sevenzip/7-Zip/19.00/7z1900.msi"
if not exist "%setupbin%\7z1900.msi" wget.exe --tries=3 --no-check-certificate -c "http://www.7-zip.org/a/7z1900.msi"
msiexec /package "%setupbin%\7z1900.msi" /quiet /norestart
if not exist "%setupbin%\7z1900-extra.7z" wget.exe --tries=3 --no-check-certificate -c "http://netcologne.dl.sourceforge.net/project/sevenzip/7-Zip/19.00/7z1900-extra.7z"
if not exist "%setupbin%\7z1900-extra.7z" wget.exe --tries=3 --no-check-certificate -c "http://www.7-zip.org/a/7z1900-extra.7z"
"%ProgramFiles%\7-Zip\7zg.exe" x -r -y -o"%ProgramFiles%\7-Zip" "%setupbin%\7z1900-extra.7z"
copy /y "%ProgramFiles%\7-Zip\7za.exe" "%sysinstall%"
copy /y "%ProgramFiles%\7-Zip\7za.exe" "%systemroot%\system32"
:: NirCMD32
echo Installing NirCMD ...
if not exist "%setupbin%\nircmd.zip" wget.exe --tries=3 --no-check-certificate -c "http://www.nirsoft.net/utils/nircmd.zip" -O "%setupbin%\nircmd.zip"
7za.exe x -r -y -x!*.chm -o"%sysinstall%" "%setupbin%\nircmd.zip"
copy /y "%sysinstall%\nircmd.exe" "%systemroot%\system32"
copy /y "%sysinstall%\nircmdc.exe" "%systemroot%\system32"
:: FAR32
echo Installing FAR ...
tasklist /fi "imagename eq far.exe" |find ":" >nul
if errorlevel 1 taskkill /f /im "far.exe"
if not exist "%setupbin%\Far30b6161.x86.20230609.msi" wget.exe --tries=3 --no-check-certificate -c "https://www.farmanager.com/files/Far30b6161.x86.20230609.msi"
msiexec /package "%setupbin%\Far30b6161.x86.20230609.msi" /quiet /norestart
if not exist "%ProgramFiles%\Far Manager\plugins\7-zip" md "%ProgramFiles%\Far Manager\plugins\7-zip"
copy /y "%ProgramFiles%\7-Zip\far\*.*" "%ProgramFiles%\Far Manager\plugins\7-zip"
regedit /s "%ProgramFiles%\Far Manager\plugins\7-zip\far7z.reg"
cd "%setupcfg%"
if not exist "%setupcfg%\far.7z" wget.exe --tries=3 --no-check-certificate -c "http://github.com/alexsupra/usetools/raw/master/setupcfg/far.7z"
7za.exe x -r -y -o"%appdata%" "%setupcfg%\far.7z"
echo nircmdc.exe elevate "%ProgramFiles%\Far Manager\far.exe" >%systemroot%\system32\far.cmd
cd "%setupbin%"
:: ConEmu32
echo Installing ConEmu ...
if not exist "%setupbin%\ConEmuSetup.230724.exe" wget.exe --tries=3 --no-check-certificate -c "https://github.com/Maximus5/ConEmu/releases/download/v23.07.24/ConEmuSetup.230724.exe"
"%setupbin%\ConEmuSetup.230724.exe" /p:x86,adm /qr
cd "%setupcfg%"
if not exist "%setupcfg%\conemu.7z" wget.exe --tries=3 --no-check-certificate -c "http://github.com/alexsupra/usetools/raw/master/setupcfg/conemu.7z"
7za.exe x -r -y -o"%programfiles%" "%setupcfg%\conemu.7z"
::copy /y "%programfiles%\conemu\conemu.xml" "%defaultuserprofile%\appdata\roaming"
copy /y "%programfiles%\conemu\conemu.xml" "%appdata%"
cd "%setupbin%"
del /f /q "%public%\desktop\ConEmu (x86).lnk" >nul
:: Notepad++32
echo Installing Notepad++ ...
if not exist "%setupbin%\npp.8.5.7.Installer.exe" wget.exe --tries=3 --no-check-certificate -c "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.5.7/npp.8.5.7.Installer.exe"
"%setupbin%\npp.8.5.7.Installer.exe" /S
:: Firefox32
echo Installing Mozilla Firefox ...
tasklist /fi "imagename eq firefox.exe" |find ":" >nul
if errorlevel 1 taskkill /f /im "firefox.exe"
if not exist "%setupbin%\Firefox Setup 120.0.exe" wget.exe --tries=3 --no-check-certificate -c "https://ftp.mozilla.org/pub/firefox/releases/120.0/win32/ru/Firefox Setup 120.0.exe"
"%setupbin%\Firefox Setup 120.0.exe" /S
:: Thunderbird32
echo Installing Mozilla Thunderbird ...
tasklist /fi "imagename eq thunderbird.exe" |find ":" >nul
if errorlevel 1 taskkill /f /im "thunderbird.exe"
if not exist "%setupbin%\Thunderbird Setup 115.5.0.exe" wget.exe --tries=3 --no-check-certificate -c "https://download-installer.cdn.mozilla.net/pub/thunderbird/releases/115.5.0/win32/ru/Thunderbird Setup 115.5.0.exe"
"%setupbin%\Thunderbird Setup 115.5.0.exe" /S
::if not exist "%setupbin%\addon-362387-latest.xpi" wget.exe --tries=3 --no-check-certificate -c "http://addons.thunderbird.net/thunderbird/downloads/latest/custom-address-sidebar/addon-362387-latest.xpi"
::copy /y "%setupbin%\addon-362387-latest.xpi" "%programfiles%\Mozilla Thunderbird\extensions"
:: LibreOffice32
echo Installing LibreOffice ...
if not exist "%setupbin%\LibreOffice_7.5.8_Win_x86.msi" wget.exe --tries=3 --no-check-certificate -c "https://mirrors.iu13.net/tdf/libreoffice/stable/7.5.8/win/x86/LibreOffice_7.5.8_Win_x86.msi"
msiexec /package "LibreOffice_7.5.8_Win_x86.msi" /quiet /norestart
:: VLC32
echo Installing VLC media player ...
if not exist "%setupbin%\vlc-3.0.19-win32.exe" wget.exe --tries=3 --no-check-certificate -c "https://get.videolan.org/vlc/3.0.19/win32/vlc-3.0.19-win32.exe"
"%setupbin%\vlc-3.0.19-win32.exe" /S
:: PureText32
echo Installing PureText ...
if not exist "%setupbin%\puretext_6.2_32-bit.zip" wget.exe --tries=3 --no-check-certificate -c "http://stevemiller.net/downloads/puretext_6.2_32-bit.zip"
if not exist "%programfiles%\puretext" md "%programfiles%\puretext"
7za.exe x -r -y -o"%programfiles%\puretext" "%setupbin%\puretext_6.2_32-bit.zip"
nircmdc.exe shortcut "%programfiles%\puretext\puretext.exe" "~$folder.common_programs$" "PureText"
:: wufuc32
if "%ntver%"=="10.0" goto osx8664
echo Installing wufuc ...
if not exist "%setupbin%\wufuc_v1.0.1.201-x86.msi" wget.exe --tries=3 --no-check-certificate -c "http://github.com/zeffy/wufuc/releases/download/v1.0.1.201/wufuc_v1.0.1.201-x86.msi"
msiexec /package "%setupbin%\wufuc_v1.0.1.201-x86.msi" /quiet /norestart
goto osx8664
::
:osx64
echo. &echo Running software APPS installation in 64-bit mode ...&echo.
if "%PROCESSOR_ARCHITECTURE%"=="x86" color 0e &echo CMD process seems to be 32-bit, its recommended to restart in 64-bit &pause
:: 7-zip64
echo Installing 7-zip ...
tasklist /fi "imagename eq 7zfm.exe" |find ":" >nul
if errorlevel 1 taskkill /f /im "7zfm.exe"
if not exist "%setupbin%\7z1900-x64.msi" wget.exe --tries=3 --no-check-certificate -c "http://netcologne.dl.sourceforge.net/project/sevenzip/7-Zip/19.00/7z1900-x64.msi"
if not exist "%setupbin%\7z1900-x64.msi" wget.exe --tries=3 --no-check-certificate -c "http://www.7-zip.org/a/7z1900-x64.msi"
msiexec /package "%setupbin%\7z1900-x64.msi" /quiet /norestart
if not exist "%setupbin%\7z1900-extra.7z" wget.exe --tries=3 --no-check-certificate -c "http://netcologne.dl.sourceforge.net/project/sevenzip/7-Zip/19.00/7z1900-extra.7z"
if not exist "%setupbin%\7z1900-extra.7z" wget.exe --tries=3 --no-check-certificate -c "http://www.7-zip.org/a/7z1900-extra.7z"
if exist "%ProgramFiles%\7-Zip" set sevenzip=%ProgramFiles%\7-Zip
if not exist "%ProgramFiles%\7-Zip" set sevenzip=%ProgramFiles(x86)%\7-Zip
"%sevenzip%\7zg.exe" x -r -y -o"%sevenzip%" "%setupbin%\7z1900-extra.7z"
copy /y "%sevenzip%\x64\7za.exe" "%sysinstall%"
copy /y "%sevenzip%\x64\7za.exe" "%systemroot%\system32"
:: NirCMD64
echo Installing NirCMD ...
if not exist "%setupbin%\nircmd-x64.zip" wget.exe --tries=3 --no-check-certificate -c "http://www.nirsoft.net/utils/nircmd-x64.zip" -O "%setupbin%\nircmd-x64.zip"
if not exist "%sysinstall%\nircmdc.exe" 7za.exe x -r -y -x!*.chm -o"%sysinstall%" "%setupbin%\nircmd-x64.zip"
copy /y "%sysinstall%\nircmd.exe" "%systemroot%\system32"
copy /y "%sysinstall%\nircmdc.exe" "%systemroot%\system32"
:: FAR64
echo Installing FAR ...
tasklist /fi "imagename eq far.exe" |find ":" >nul
if errorlevel 1 taskkill /f /im "far.exe"
if not exist "%setupbin%\Far30b6161.x64.20230609.msi" wget.exe --tries=3 --no-check-certificate -c "https://www.farmanager.com/files/Far30b6161.x64.20230609.msi"
msiexec /package "%setupbin%\Far30b6161.x64.20230609.msi" /quiet /norestart
if not exist "%ProgramFiles%\Far Manager\plugins\7-zip" md "%ProgramFiles%\Far Manager\plugins\7-zip"
copy /y "%ProgramFiles%\7-Zip\far\*.*" "%ProgramFiles%\Far Manager\plugins\7-zip"
regedit /s "%ProgramFiles%\Far Manager\plugins\7-zip\far7z.reg"
cd "%setupcfg%"
if not exist "%setupcfg%\far.7z" wget.exe --tries=3 --no-check-certificate -c "http://github.com/alexsupra/usetools/raw/master/setupcfg/far.7z"
7za.exe x -r -y -o"%appdata%" "%setupcfg%\far.7z"
echo nircmdc.exe elevate "%ProgramFiles%\Far Manager\far.exe" >%systemroot%\system32\far.cmd
cd "%setupbin%"
:: ConEmu64
echo Installing ConEmu ...
if not exist "%setupbin%\ConEmuSetup.230724.exe" wget.exe --tries=3 --no-check-certificate -c "https://github.com/Maximus5/ConEmu/releases/download/v23.07.24/ConEmuSetup.230724.exe"
"%setupbin%\ConEmuSetup.230724.exe" /p:x64,adm /qr
cd "%setupcfg%"
if not exist "%setupcfg%\conemu.7z" wget.exe --tries=3 --no-check-certificate -c "http://github.com/alexsupra/usetools/raw/master/setupcfg/conemu.7z"
7za.exe x -r -y -o"%programfiles%" "%setupcfg%\conemu.7z"
copy /y "%programfiles%\conemu\conemu.xml" "%defaultuserprofile%\appdata\roaming"
copy /y "%programfiles%\conemu\conemu.xml" "%appdata%"
del /f /q "%public%\desktop\ConEmu (x64).lnk" >nul 2>&1
cd "%setupbin%"
:: Notepad++64
echo Installing Notepad++ ...
if not exist "%setupbin%\npp.8.5.7.Installer.x64.exe" wget.exe --tries=3 --no-check-certificate -c "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.5.7/npp.8.5.7.Installer.x64.exe"
"%setupbin%\npp.8.5.7.Installer.x64.exe" /S
:: Firefox64
echo Installing Mozilla Firefox ...
tasklist /fi "imagename eq firefox.exe" |find ":" >nul
if errorlevel 1 taskkill /f /im "firefox.exe"
if not exist "%setupbin%\Firefox Setup 120.0.msi" wget.exe --tries=3 --no-check-certificate -c "https://ftp.mozilla.org/pub/firefox/releases/120.0/win64/ru/Firefox Setup 120.0.msi"
msiexec /package "Firefox Setup 120.0.msi" /quiet /norestart
::if not exist "%programfiles%\mozilla firefox\browser\default" md "%programfiles%\mozilla firefox\browser\default"
::echo user_pref("browser.urlbar.placeholderName", "Google"); >"%programfiles%\mozilla firefox\browser\default\prefs.js"
:: Thunderbird64
echo Installing Mozilla Thunderbird ...
tasklist /fi "imagename eq thunderbird.exe" |find ":" >nul
if errorlevel 1 taskkill /f /im "thunderbird.exe"
if not exist "%setupbin%\Thunderbird Setup 115.5.0.msi" wget.exe --tries=3 --no-check-certificate -c "https://download-installer.cdn.mozilla.net/pub/thunderbird/releases/115.5.0/win64/ru/Thunderbird Setup 115.5.0.msi"
msiexec /package "%setupbin%\Thunderbird Setup 115.5.0.msi" /quiet /norestart
::if not exist "%setupbin%\addon-362387-latest.xpi" wget.exe --tries=3 --no-check-certificate -c "http://addons.thunderbird.net/thunderbird/downloads/latest/custom-address-sidebar/addon-362387-latest.xpi"
::copy /y "%setupbin%\addon-362387-latest.xpi" "%programfiles%\Mozilla Thunderbird\extensions"
echo Installing LibreOffice ...
if not exist "%setupbin%\LibreOffice_7.6.3_Win_x86-64.msi" wget.exe --tries=3 --no-check-certificate -c "http://libreoffice-mirror.rbc.ru/pub/libreoffice/libreoffice/stable/7.6.3/win/x86_64/LibreOffice_7.6.3_Win_x86-64.msi"
msiexec /package "LibreOffice_7.6.3_Win_x86-64.msi" /quiet /norestart
:: VLC64
echo Installing VLC media player ...
if not exist "%setupbin%\vlc-3.0.19-win64.exe" wget.exe --tries=3 --no-check-certificate -c "https://get.videolan.org/vlc/3.0.19/win64/vlc-3.0.19-win64.exe"
"%setupbin%\vlc-3.0.19-win64.exe" /S
:: PureText64
echo Installing PureText ...
if not exist "%setupbin%\puretext_6.2_64-bit.zip" wget.exe --tries=2 --no-check-certificate -c "http://stevemiller.net/downloads/puretext_6.2_64-bit.zip"
if not exist "%programfiles%\puretext" md "%programfiles%\puretext"
7za.exe x -r -y -o"%programfiles%\puretext" "%setupbin%\puretext_6.2_64-bit.zip"
nircmdc.exe shortcut "%programfiles%\puretext\puretext.exe" "~$folder.common_programs$" "PureText"
if "%ntver%"=="10.0" goto osx8664
:: wufuc64
echo Installing wufuc ...
if not exist "%setupbin%\wufuc_v1.0.1.201-x64.msi" wget.exe --tries=3 --no-check-certificate -c "http://github.com/zeffy/wufuc/releases/download/v1.0.1.201/wufuc_v1.0.1.201-x64.msi"
msiexec /package "%setupbin%\wufuc_v1.0.1.201-x64.msi" /quiet /norestart
::
:osx8664
reg delete "HKEY_CLASSES_ROOT\Directory\shell\AddToPlaylistVLC" /f >nul
reg delete "HKEY_CLASSES_ROOT\Directory\shell\PlayWithVLC" /f >nul
:: sysclean
echo Installing system clean up script ...
cd "%sysinstall%"
if not exist "%sysinstall%\sysclean.cmd" wget.exe --tries=3 --no-check-certificate -c "http://github.com/alexsupra/usetools/raw/master/sysclean.cmd"
copy /y "%sysinstall%\sysclean.cmd" %systemroot%\system32
echo nircmdc.exe elevate %systemroot%\system32\sysclean.cmd -c >%systemroot%\system32\sysc.cmd
cd "%setupbin%"
:: Anvir
echo Installing Anvir ...
tasklist /fi "imagename eq anvir.exe" |find ":" >nul
if errorlevel 1 taskkill /f /im "anvir.exe"
if not exist "%setupbin%\anvirrus-portable.zip" (
	wget.exe --tries=3 --no-check-certificate -c "http://www.anvir.net/downloads/anvirrus.zip"
	7za.exe x -r -y -o"%setupbin%" "%setupbin%\anvirrus.zip"
	)
7za.exe x -r -y -o"%programfiles%\anvir" "%setupbin%\anvirrus-portable.zip"
cd "%setupcfg%"
if not exist "%setupcfg%\anvir.7z" wget.exe --tries=3 --no-check-certificate -c "http://github.com/alexsupra/usetools/raw/master/setupcfg/anvir.7z"
7za.exe x -r -y -o"%programfiles%\anvir" "%setupcfg%\anvir.7z"
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "anvir task manager" /t reg_sz /d "\"%programfiles%\anvir\anvir.exe\" minimized" /f
nircmdc.exe regsetval sz "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\anvir.exe" "" "%programfiles%\anvir\anvir.exe"
nircmdc.exe regsetval sz "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\anvir.exe" "Path" "%programfiles%\anvir\"
nircmdc.exe shortcut "%programfiles%\anvir\anvir.exe" "~$folder.common_programs$" "Anvir"
::echo nircmdc.exe elevate "%programfiles%\anvir\anvir.exe" >%systemroot%\system32\anvir.cmd
cd "%setupbin%"
:: ClamWin
::echo Installing ClamWin ...
::tasklist /fi "imagename eq clamwin.exe" |find ":" >nul
::if errorlevel 1 taskkill /f /im "clamwin.exe"
::tasklist /fi "imagename eq clamtray.exe" |find ":" >nul
::if errorlevel 1 taskkill /f /im "clamtray.exe"
::if not exist "%setupbin%\clamwin-0.103.2.1-setup.exe" wget.exe --tries=3 --no-check-certificate -c "http://deac-ams.dl.sourceforge.net/project/clamwin/clamwin/0.103.2.1/clamwin-0.103.2.1-setup.exe"
::start clamwin-0.103.2.1-setup.exe /VERYSILENT
:: Unreal Commander
echo Installing Unreal Commander ...
tasklist /fi "imagename eq UnrealCommander32.exe" |find ":" 2>nul
if errorlevel 1 taskkill /f /im "UnrealCommander32.exe"
tasklist /fi "imagename eq UnrealCommander64.exe" |find ":" 2>nul
if errorlevel 1 taskkill /f /im "UnrealCommander64.exe"
if not exist "%setupbin%\uncomsetup.exe" wget.exe --tries=3 --no-check-certificate -c "http://x-diesel.com/download/uncomsetup.exe"
"%setupbin%\uncomsetup.exe" /VERYSILENT
nircmdc.exe killprocess UnrealCommander32.exe
nircmdc.exe killprocess UnrealCommander64.exe
if %osarch%==x86 (
	if not exist "%setupbin%\notepad2_4.2.25_x86.zip" wget.exe --tries=3 --no-check-certificate -c "http://www.flos-freeware.ch/zip/notepad2_4.2.25_x86.zip"
	taskkill /f /im "UnrealCommander32.exe" /F
	7za.exe x -r -y -o"%systemdrive%\unreal commander" "%setupbin%\notepad2_4.2.25_x86.zip"	
	)
if %osarch%==x64 (
	if not exist "%setupbin%\notepad2_4.2.25_x64.zip" wget.exe --tries=3 --no-check-certificate -c "http://www.flos-freeware.ch/zip/notepad2_4.2.25_x64.zip"
	taskkill /IM "UnrealCommander64.exe" /F
	7za.exe x -r -y -o"%systemdrive%\unreal commander" "%setupbin%\notepad2_4.2.25_x64.zip"
	)
cd "%setupcfg%"
if not exist "%setupcfg%\unreal.7z" wget.exe --tries=3 --no-check-certificate -c "http://github.com/alexsupra/usetools/raw/master/setupcfg/unreal.7z"
if not exist "%setupcfg%\notepad2.7z" wget.exe --tries=3 --no-check-certificate -c "http://github.com/alexsupra/usetools/raw/master/setupcfg/notepad2.7z"
taskkill /IM "UnrealCommander*" /F 2>nul
7za.exe x -r -y -o"%systemdrive%\unreal commander" "%setupcfg%\unreal.7z"
if not exist "%defaultuserprofile%\appdata\roaming\unreal commander" md "%defaultuserprofile%\appdata\roaming\unreal commander"
copy /y "%systemdrive%\unreal commander\uncom.ini" "%defaultuserprofile%\appdata\roaming\unreal commander"
copy /y "%systemdrive%\unreal commander\uncomstyles.ini" "%defaultuserprofile%\appdata\roaming\unreal commander"
if not exist "%appdata%\unreal commander" md "%appdata%\unreal commander"
copy /y "%systemdrive%\unreal commander\uncom.ini" "%appdata%\unreal commander"
copy /y "%systemdrive%\unreal commander\uncomstyles.ini" "%appdata%\unreal commander"
7za.exe x -r -y -o"%systemdrive%\unreal commander" "%setupcfg%\notepad2.7z"
if not exist %systemroot%\fonts\gost_a.ttf (
	copy /y "%systemdrive%\unreal commander\fonts\gost_a.ttf" %systemroot%\fonts
	reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /v "GOST type A (TrueType)" /t reg_sz /d "gost_a.ttf" /f
	)
if not exist %systemroot%\fonts\gost_b.ttf (
	copy /y "%systemdrive%\unreal commander\fonts\gost_b.ttf" %systemroot%\fonts
	reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /v "GOST type B (TrueType)" /t reg_sz /d "gost_b.ttf" /f
	)
if not exist %systemroot%\fonts\droid.ttf (
	copy /y "%systemdrive%\unreal commander\fonts\droid.ttf" %systemroot%\fonts
	reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /v "Droid Sans (TrueType)" /t reg_sz /d "droid.ttf" /f
	)
if not exist %systemroot%\fonts\droid_b.ttf (
	copy /y "%systemdrive%\unreal commander\fonts\droid_b.ttf" %systemroot%\fonts
	reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /v "Droid Sans Bold (TrueType)" /t reg_sz /d "droid_b.ttf" /f
	)
if not exist %systemroot%\fonts\droid_m.ttf (
	copy /y "%systemdrive%\unreal commander\fonts\droid_m.ttf" %systemroot%\fonts
	reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /v "Droid Sans Mono (TrueType)" /t reg_sz /d "droid_m.ttf" /f
	)
reg delete "HKEY_CLASSES_ROOT\directory\shell\ Unreal Commander" /f 2>nul
cd "%setupbin%"
:: OpenOffice
::echo Installing OpenOffice.org ...
::if not exist "%setupbin%\Apache_OpenOffice_4.1.14_Win_x86_install_ru.exe" wget.exe --tries=3 --no-check-certificate -c "http://cfhcable.dl.sourceforge.net/project/openofficeorg.mirror/4.1.14/binaries/ru/Apache_OpenOffice_4.1.14_Win_x86_install_ru.exe"
::"%setupbin%\Apache_OpenOffice_4.1.14_Win_x86_install_ru.exe" /S
::rundll32.exe advpack.dll,DelNodeRunDLL32 "%userprofile%\desktop\OpenOffice 4.1.14 (ru) Installation Files"
:: XnView
echo Installing XnView ...
if not exist "%setupbin%\XnView-win-full.exe" wget.exe --tries=2 --no-check-certificate -c "http://download.xnview.com/XnView-win-full.exe"
"%setupbin%\XnView-win-full.exe" /VERYSILENT
:: Foxit Reader
echo Installing Foxit Reader ...
tasklist /fi "imagename eq FoxitReader.exe" |find ":" >nul
if errorlevel 1 taskkill /f /im "FoxitReader.exe"
if not exist "%setupbin%\FoxitPDFReader20232_L10N_Setup_Prom.exe" wget.exe --tries=2 --no-check-certificate -c "http://cdn78.foxitsoftware.com/product/phantomPDF/desktop/win/2023.2.0/FoxitPDFReader20232_L10N_Setup_Prom.exe"
"%setupbin%\FoxitPDFReader20232_L10N_Setup_Prom.exe" /silent
:: foobar2000
echo Installing foobar2000 ...
if not exist "%setupbin%\foobar2000_v1.5.2.exe" wget.exe --tries=3 --no-check-certificate -c "http://www.free-codecs.com/download_soft.php?d=6322151e23e301644d623c087e3cd99c&s=145&r=&f=foobar2000.htm" -O "foobar2000_v1.5.2.exe"
if not exist "%setupcfg%\foobar2k.7z" (
	cd "%setupcfg%"
	wget.exe --tries=3 --no-check-certificate -c "http://github.com/alexsupra/usetools/raw/master/setupcfg/foobar2k.7z"
	cd "%sysinstall%"
	)
"%setupbin%\foobar2000_v1.5.2.exe" /S
if %osarch%==x86 set fooprogdir=%programfiles%\foobar2000
if %osarch%==x64 set fooprogdir=%programfiles(x86)%\foobar2000
7za.exe x -r -y -o"%fooprogdir%" "%setupcfg%\foobar2k.7z"
xcopy "%fooprogdir%\appdata" "%appdata%\foobar2000" /i /y /s /r /c
:: WinDirStat
echo Installing WinDirStat ...
if not exist "%setupbin%\wds_current_setup.exe" wget.exe --tries=2 --no-check-certificate -c "http://windirstat.net/wds_current_setup.exe"
"%setupbin%\wds_current_setup.exe" /S
del /f /q "%userprofile%\desktop\WinDirStat.lnk"
:: SIV
echo Installing SIV ...
if not exist "%setupbin%\siv_v5.73.zip" wget.exe --tries=2 --no-check-certificate -c "https://delivery2.filecroco.com/kits_6/siv_v5.73.zip"
7za.exe x -r -y -o"%programfiles%\siv" "%setupbin%\siv_v5.73.zip"
if %osarch%==x86 nircmdc.exe shortcut "%programfiles%\siv\siv32x.exe" "~$folder.common_programs$" "SIV"
if %osarch%==x64 nircmdc.exe shortcut "%programfiles%\siv\siv64x.exe" "~$folder.common_programs$" "SIV"
:: HWMonitor
echo Installing HWMonitor ...
if not exist "%setupbin%\hwmonitor_1.52.exe" wget.exe --tries=2 --no-check-certificate -c "https://download.cpuid.com/hwmonitor/hwmonitor_1.52.exe"
"%setupbin%\hwmonitor_1.52.exe" /VERYSILENT
del /f /q "%public%\desktop\CPUID HWMonitor.lnk"
:: CrystalDiskInfo
echo Installing CrystalDiskInfo ...
if not exist "%setupbin%\CrystalDiskInfo9_1_1.zip" wget.exe --tries=2 --no-check-certificate -c "https://crystalmark.info/download/zz/CrystalDiskInfo9_1_1.zip"
7za.exe x -r -y -o"%programfiles%\crystaldiskinfo" "%setupbin%\CrystalDiskInfo9_1_1.zip"
if %osarch%==x86 nircmdc.exe shortcut "%programfiles%\crystaldiskinfo\DiskInfo32.exe" "~$folder.common_programs$" "CrystalDiskInfo"
if %osarch%==x64 nircmdc.exe shortcut "%programfiles%\crystaldiskinfo\DiskInfo64.exe" "~$folder.common_programs$" "CrystalDiskInfo"
:: Keyboard LEDs
echo Installing Keyboard LEDs ...
if not exist "%setupbin%\keyboard-leds.exe" wget.exe --tries=2 --no-check-certificate -c "http://keyboard-leds.com/files/keyboard-leds.exe"
"%setupbin%\keyboard-leds.exe" /S
del /f /q "%public%\desktop\Keyboard LEDs.lnk"
:: dotSwitcher
echo Installing dotSwitcher ...
if errorlevel 1 taskkill /f /im "dotswitcher.exe"
if not exist "%setupbin%\dotswitcher.exe" wget.exe --tries=2 --no-check-certificate -c "https://github.com/kurumpa/dotSwitcher/releases/download/v0.45-alpha/dotSwitcher.exe"
if %osarch%==x86 set dotswitcherdir=%programfiles%\dotswitcher
if %osarch%==x64 set dotswitcherdir=%ProgramFiles(x86)%\dotswitcher
if not exist "%dotswitcherdir%" md "%dotswitcherdir%"
copy /y "%setupbin%\dotswitcher.exe" "%dotswitcherdir%"
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "dotswitcher" /t reg_sz /d "%dotswitcherdir%\dotswitcher\dotswitcher.exe" /f
:: Classic Shell
if "%ntver%"=="6.1" goto dotnetfx
if "%ntname%"=="Windows 11" goto openshell
echo Installing Classic Shell ...
if not exist "%setupbin%\ClassicShellSetup_4_3_1-ru.exe" wget.exe --tries=3 --no-check-certificate -c "http://netcologne.dl.sourceforge.net/project/classicshell/Version 4.3.1 general release/ClassicShellSetup_4_3_1-ru.exe"
"%setupbin%\ClassicShellSetup_4_3_1-ru.exe" /quiet
if %osarch%==x86 regsvr32 /u /s "%programfiles%\classic shell\classicexplorer32.dll"
if %osarch%==x64 %systemroot%\syswow64\regsvr32.exe /u /s "%programfiles%\classic shell\classicexplorer64.dll"
goto dotnetfx_win81
::
:openshell
:: Open-Shell
echo Installing Open-Shell ...
if not exist "%setupbin%\OpenShellSetup_4_4_191.exe" wget.exe --tries=3 --no-check-certificate -c "https://github.com/Open-Shell/Open-Shell-Menu/releases/download/v4.4.191/OpenShellSetup_4_4_191.exe"
"%setupbin%\OpenShellSetup_4_4_191.exe" /quiet
if %osarch%==x86 regsvr32 /u /s "%programfiles%\open-shell\classicexplorer32.dll"
if %osarch%==x64 %systemroot%\syswow64\regsvr32.exe /u /s "%programfiles%\open-shell\classicexplorer64.dll"
:: ExplorerPatcher
echo Installing ExplorerPatcher ...
if not exist "%setupbin%\ep_setup.exe" wget.exe --tries=3 --no-check-certificate -c "https://github.com/valinet/ExplorerPatcher/releases/download/22621.2428.59.1_a7c87ce/ep_setup.exe"
"%setupbin%\ep_setup.exe"
::
:dotnetfx
:: DotnetFX
echo Installing DotnetFX ...
if "%ntver%" neq "6.1" goto dotnetfx_win81
if not exist "%setupbin%\dotnetfx35.exe" wget.exe --tries=3 --no-check-certificate -c "http://download.microsoft.com/download/2/0/e/20e90413-712f-438c-988e-fdaa79a8ac3d/dotnetfx35.exe"
"%setupbin%\dotnetfx35.exe" /s
goto apply_setup
:dotnetfx_win81
DISM /Online /Enable-Feature /FeatureName:NetFx3 /All
::
:apply_setup
:: Active Setup
echo Applying sysinstall.cmd to Active Setup ...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Active Setup\Installed Components\sysinstall" /v "" /t reg_sz /d "sysinstall" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Active Setup\Installed Components\sysinstall" /v "component id" /t reg_sz /d "sysinstall" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Active Setup\Installed Components\sysinstall" /v "version" /t reg_sz /d "%sysinstall_version%" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Active Setup\Installed Components\sysinstall" /v "date" /t reg_sz /d "%date%" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Active Setup\Installed Components\sysinstall" /v "isinstalled" /t reg_dword /d "1" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Active Setup\Installed Components\sysinstall" /v "stubpath" /t reg_expand_sz /d "\"%sysinstall%\sysinstall.cmd\" -s" /f
:: boot menu
if "%ntver%" neq "6.1" (
	echo Updating Windows boot menu settings ...
	bcdedit /set "{bootmgr}" displaybootmenu yes
	bcdedit /timeout 1
	)
if "%ntver%" neq "10.0" goto tango_patcher
:: system clean-up
echo Performing system clean-up ...
taskkill /f /im OneDrive.exe >nul 2>&1
OneDriveSetup.exe /uninstall >nul 2>&1
:tango_patcher
:: Tango Patcher
echo Installing Windows Tango Patcher ...
if not exist "%setupbin%\WinTango-Patcher-16.12.24-offline.exe" wget.exe --tries=3 --no-check-certificate -c "http://github.com/alexsupra/WinTango-Patcher/releases/download/v16.12.24/WinTango-Patcher-16.12.24-offline.exe"
nircmdc.exe initshutdown "sysinstall.cmd: system will be restarted automatically in a 3 min." 180 force reboot
"%setupbin%\WinTango-Patcher-16.12.24-offline.exe" /S
echo. &echo INSTALLATION IS COMPLETED
if "%1"=="-u" exit
if "%ntver%"=="10.0" echo [40;92mPRESS ANY KEY TO EXIT[0m
if "%ntver%" neq "10.0" (
	echo PRESS ANY KEY TO EXIT
	color 0a
	)
pause >nul &exit
:reboot
echo. &echo Trying to restart the machine ...
shutdown /r /f
nircmdc.exe "Trying to restart the machine ..." 1 force reboot
exit
:setup
nircmdc.exe shortcut "%systemroot%\system32\cmd.exe" "~$folder.programs$" "CMD"
nircmdc.exe shortcut "%programfiles%\videolan\vlc\vlc.exe" "~$folder.appdata$\microsoft\windows\sendto" "VLC"
copy /y "%programfiles%\conemu\conemu.xml" "%appdata%"
if not exist "%appdata%\unreal commander" md "%appdata%\unreal commander"
copy /y "%systemdrive%\unreal commander\uncom.ini" "%appdata%\unreal commander"
copy /y "%systemdrive%\unreal commander\uncomstyles.ini" "%appdata%\unreal commander"
7za.exe x -r -y -o"%appdata%" "%setupcfg%\far.7z"
if %osarch%==x86 set fooprogdir=%proframfiles%\foobar2000
if %osarch%==x64 set fooprogdir=%proframfiles(x86)%\foobar2000
xcopy "%fooprogdir%\appdata" "%appdata%\foobar2000" /i /y /s /r /c
exit
::