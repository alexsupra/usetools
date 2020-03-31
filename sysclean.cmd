:: sysclean.cmd - universal system clean up script
:: for 32/64 bits OS Windows NT 6.1, 6.2, 6.3, 10.0
:: https://github.com/alexsupra/usetools
@echo off
color 20
chcp 866 >nul
net session >nul 2>&1
if %errorLevel% neq 0 echo Administrative permissions check failure! &echo Please restart as admin. &color 0e &pause &exit
for /f "tokens=2*" %%a in ('reg query "hklm\hardware\description\system\centralprocessor\0" /v "ProcessorNameString"') do set "cpuname=%%b"
echo %cpuname%
for /f "tokens=4-5 delims=. " %%i in ('ver') do set ntver=%%i.%%j
if "%ntver%"=="4.0" echo OS Windows NT %ntver% is not supported &color 0e &pause
if "%ntver%"=="5.0" echo OS Windows NT %ntver% is not supported &color 0e &pause
if "%ntver%"=="5.1" echo OS Windows NT %ntver% is not supported &color 0e &pause
if "%ntver%"=="5.2" echo OS Windows NT %ntver% is not supported &color 0e &pause
echo %OS% %ntver% %PROCESSOR_ARCHITECTURE%
echo     ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
echo     ÛÛ    ÛÛ ÛÛßßßßÛÛ ÛßßßßßßÛ ßßßÛÛßßß ÛßßßßßßÛ ÛßßßßßßÛ ÛÛ       ÛÛßßßßÛÛ 
echo     ÛÛ    ÛÛ ÛÛ       Û           ÛÛ    Û      Û Û      Û ÛÛ       ÛÛ       
echo     ÛÛ    ÛÛ  ßßßßßßÛ Ûßßßßß      ÛÛ    Û      Û Û      Û ÛÛ        ßßßßßßÛ  
echo     ÛÛ    ÛÛ ÛÛ     Û Û      Û    ÛÛ    Û      Û Û      Û ÛÛ    ÛÛ ÛÛ     Û 
echo      ßßßßßßß ßßßßßßßß ßßßßßßßß    ßß    ßßßßßßßß ßßßßßßßß ßßßßßßßß ßßßßßßßß  
echo     ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
echo     ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
echo     ³                sysclean.cmd - system clean up script                ³
echo     ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
echo.
echo Cleaning system temporary and cache directories...
dir /b %systemroot%\temp >temp.list
for /f "delims=" %%a in (temp.list) do call rundll32.exe advpack.dll,DelNodeRunDLL32 "%systemroot%\temp\%%a"
dir /b %temp% >temp.list
for /f "delims=" %%a in (temp.list) do call rundll32.exe advpack.dll,DelNodeRunDLL32 "%temp%\%%a"
dir /b %tmp% >temp.list
for /f "delims=" %%a in (temp.list) do call rundll32.exe advpack.dll,DelNodeRunDLL32 "%tmp%\%%a"
dir /b %systemroot%\prefetch >temp.list
for /f "delims=" %%a in (temp.list) do call rundll32.exe advpack.dll,DelNodeRunDLL32 "%systemroot%\prefetch\%%a"
dir /b "%localappdata%\Microsoft\Windows\Explorer" >temp.list
for /f "delims=" %%a in (temp.list) do call rundll32.exe advpack.dll,DelNodeRunDLL32 "%localappdata%\Microsoft\Windows\Explorer\%%a"
dir /b "%localappdata%\Microsoft\Windows\Caches" >temp.list
for /f "delims=" %%a in (temp.list) do call rundll32.exe advpack.dll,DelNodeRunDLL32 "%localappdata%\Microsoft\Windows\Caches\%%a"
::
echo Cleaning applications temporary and cache directories...
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
echo Cleaning WinSxS directory...
dism.exe /online /Cleanup-Image /StartComponentCleanup
echo Cleaning Recycle.Bin...
for %%p in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do if exist "%%p:\$Recycle.Bin" rundll32.exe advpack.dll,DelNodeRunDLL32 "%%p:\$Recycle.Bin"
echo Ready. &echo. &color 0a &pause &exit
::