:: netreset.cmd - network subsystem reset script
:: for 32/64-bits OS Windows NT 6.1, 6.2, 6.3, 10.0
:: https://github.com/alexsupra/usetools
@echo off &cls
set netreset_version=2602.01
chcp 866 >nul
net session >nul 2>&1
if %errorLevel% neq 0 title Administrative permissions check failure &echo Administrative permissions check failure!!&echo RESTART AS ADMINISTRATOR&color 0e &pause &exit
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
title %0 &echo %username%@%computername%
::
echo     ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
echo     ÛÛ    ÛÛ ÛÛßßßßÛÛ ÛßßßßßßÛ ßßßÛÛßßß ÛßßßßßßÛ ÛßßßßßßÛ ÛÛ       ÛÛßßßßÛÛ 
echo     ÛÛ    ÛÛ ÛÛ       Û           ÛÛ    Û      Û Û      Û ÛÛ       ÛÛ       
echo     ÛÛ    ÛÛ  ßßßßßßÛ Ûßßßßß      ÛÛ    Û      Û Û      Û ÛÛ        ßßßßßßÛ  
echo     ÛÛ    ÛÛ ÛÛ     Û Û      Û    ÛÛ    Û      Û Û      Û ÛÛ    ÛÛ ÛÛ     Û 
echo      ßßßßßßß ßßßßßßßß ßßßßßßßß    ßß    ßßßßßßßß ßßßßßßßß ßßßßßßßß ßßßßßßßß  
echo     ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
echo     ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
echo     ³    netreset.cmd - reset Windows network subsystem v%netreset_version%          ³
echo     ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
echo.
::
if "%ntver%"=="10.0" goto menu_win10
:menu
echo. &echo [1] Reset Winsock, IP configuration and DNS Cache
echo [2] Reset NetBIOS, Winsock and DNS Cache
echo [3] Remove all network interfaces and settings
echo [0] Reboot
echo [x] Exit &echo.
set userinput=0
set /p userinput=Input your choice and press enter [1/2/3/0/x]:
if %userinput%==0 exit
if %userinput%==1 goto reset
if %userinput%==2 goto netbios
if %userinput%==3 goto remove
if %userinput%==0 shutdown /r /t 0
if %userinput%==x exit
echo Input seems to be incorrect. Please try one more time
goto menu
::
:menu_win10
echo. &echo [50;93m[1] Reset Winsock, IP configuration and DNS Cache[0m
echo [50;93m[2] Reset NetBIOS, Winsock and DNS Cache[0m
echo [50;93m[3] Remove all network interfaces and settings[0m
echo [50;93m[0] Reboot[0m
echo [50;93m[x] Exit &echo.[0m
set userinput=0
set /p userinput=[50;93mInput your choice and press enter [1/2/3/4/5/6/7/0]:[0m
if %userinput%==0 exit
if %userinput%==1 goto reset
if %userinput%==2 goto netbios
if %userinput%==3 goto remove
if %userinput%==0 shutdown /r /t 0
if %userinput%==x exit
echo Input seems to be incorrect. Please try one more time
goto menu_win10
::
:reset
netsh winsock reset
netsh int ip reset
ipconfig /flushdns
if "%ntver%"=="10.0" goto menu_win10
goto menu
::
:netbios
nbtstat -R
nbtstat -RR
netsh winsock reset
ipconfig /flushdns
if "%ntver%"=="10.0" goto menu_win10
goto menu
::
:remove
netcfg -d
if "%ntver%"=="10.0" goto menu_win10
goto menu
::