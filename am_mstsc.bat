@echo off
REM /*==================================
REM Alex Meys
REM ===================================*/

REGEDIT4

CLS
REGEDIT.EXE /S "%~f0"
echo Welkom bij am_mstsc
set /p server=Geef een server op (mail.bedrijf.be) :

echo Verbonden met %server%
mstsc /v:%server% /f

echo Even geduld opruimen van bestanden
REM Systeem tijd geven om bestanden te laten aanmaken.
ping 192.168.99.256 -n 1 -w 3000 > nul
REM Opkuisen registry sleutel laatste connectie (deze)
reg.exe delete "HKEY_CURRENT_USER\Software\Microsoft\Terminal Server Client\Default" /v MRU0 /f

REM instellen standaard waarden user profiel
set KEY_NAME="HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders"
set VALUE_NAME=Personal

REM opzoeken van Windows Versie
VER | FINDSTR /L "5.1." > NUL
IF %ERRORLEVEL% EQU 0 GOTO WXP

VER | FINDSTR /L "6.0." > NUL
IF %ERRORLEVEL% EQU 0 GOTO W7

VER | FINDSTR /L "6.1." > NUL
IF %ERRORLEVEL% EQU 0 GOTO W7

REM WXP
:WXP
FOR /F "usebackq skip=4 tokens=1-3" %%A IN (`REG QUERY %KEY_NAME% /v %VALUE_NAME% 2^>nul`) DO (
    set ValueName=%%A
    set ValueType=%%B
    set ValueValue=%%C
)
if defined ValueName (
    GOTO VervolgXP
) else (
	GOTO VervolgXP
)

REM W7
:W7
FOR /F "usebackq skip=2 tokens=1-3" %%D IN ('REG QUERY %KEY_NAME% /v %VALUE_NAME% 2^>nul') DO (
    set ValueNme=%%D
    set ValueTpe=%%E
    set ValeVale=%%F
)
if defined ValueNme (
	GOTO VervolgW7
) else (
	GOTO VervolgW7
)

REM Opkuisen WXP
:VervolgXP
IF EXIST %ValueValue%Default.rdp del /Q /A:H %ValueValue%Default.rdp
IF EXIST "%USERPROFILE%\Mijn Documenten\Default.rdp" del /Q /A:H "%USERPROFILE%\Mijn Documenten\Default.rdp"
IF EXIST "%USERPROFILE%\My Documents\Default.rdp" del /Q /A:H "%USERPROFILE%\My Documents\Default.rdp"
GOTO:EIND

REM Opkuisen W7 Jump list mstsc
:VervolgW7
IF EXIST %ValeVale%Default.rdp del /Q /A:H %ValeVale%Default.rdp
IF EXIST "%USERPROFILE%\Documents\Default.rdp" del /Q /A:H "%USERPROFILE%\Documents\Default.rdp"
IF EXIST "%USERPROFILE%\Mijn Documenten\Default.rdp" del /Q "%USERPROFILE%\Mijn Documenten\Default.rdp"
IF EXIST "%USERPROFILE%\My Documents\Default.rdp" del /Q "%USERPROFILE%\My Documents\Default.rdp"
IF EXIST "%APPDATA%\Microsoft\Windows\Recent\AutomaticDestinations\1bc392b8e104a00e.automaticDestinations-ms" del /Q "%APPDATA%\Microsoft\Windows\Recent\AutomaticDestinations\1bc392b8e104a00e.automaticDestinations-ms"

:EIND
echo Alles opgeruimd. Tot Later!
ping 192.168.99.256 -n 1 -w 1000 > nul
