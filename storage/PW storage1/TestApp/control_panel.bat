@echo off
setlocal EnableDelayedExpansion 
title Control Panel
color 0F
 
:TOP

IF EXIST installer.bat goto INSTALL
goto VARS

:MAIN_MENU
color 0F
cls
echo.
echo Eingelogt als %user_name%
echo ----------------------------------
echo #				#
echo #	1) login		#
echo #	2) User anschauen	#
echo #	3) Ordner		#
echo #	4) EXIT			#
echo #				#
echo ----------------------------------
echo.
echo Aktion
set/p "cho=>"

if %cho% == 1 goto LOGIN
if %cho% == 2 goto VIEW_USER
if %cho% == 3 goto VIEW_FOLDER
if %cho% == 4 goto GOODBYE

goto MAIN_MENU
goto END


REM --------- LOGIN BEREICH ---------  
:LOGIN
cls
if not "%user_name%" == "Guest" goto ALREADY_SIGNIN  

echo Username
set/p "user_name=>"
echo.
echo Passwort
set/p "user_pw=>"

set user=%user_name% %user_pw%

FOR /f "delims=" %%i in (user.txt) DO (
	if "%%i" == "%user%" goto SUCCES
	goto FAIL	
)

:SUCCES 
set "go=MAIN_MENU"
call :CREATE_LOG

:FAIL
set "str=GuestName"
set "go=FAIL_NAME"
call :SEARCH_STRING
:FAIL_NAME
set "user_name=%output%"
set "user_pw="
if "%fails%" == "" set "fails=0"
for /f "delims=" %%b in ('findstr /i /b "MaxFails" "cfg.txt"') do set "text=%%b"
set "maxFails=%text:MaxFails =%" 
set/a "fails=%fails%+1" 
set/a "fail_msg=%maxFails% - %fails%"
if "%fail_msg%" LEQ "0" goto FAIL_COUNTDOWN

echo.
echo Dein Username oder Passwort ist FALSCH
echo Du hast noch %fail_msg% versuche verbleibend

timeout /t 2 > nul	
goto LOGIN

:ALREADY_SIGNIN
cls
echo.
echo Du bist bereits eingeloggt !
echo.
echo.
echo %user_name%
echo. 

timeout /t 3 > nul
goto MAIN_MENU

:FAIL_COUNTDOWN
cls
echo.
echo Sie muessen noch %countdown% warten
echo danach werden sie wieder in das Main Menu gebracht !

set/a "i=%i% + 1"
set/a "countdown=11 - %i%"
if "%countdown%" LEQ "0" goto MAIN_MENU

timeout /t 1 > nul
goto FAIL_COUNTDOWN 
REM ---- LOGIN BEREICH ENDE ------ 


REM --------- USER ANZEIGEN --------- 
:VIEW_USER
cls
for %%f in ("user.txt") do echo Last Change: %%~tf 
if "%counter%" == "" set "counter=1"
for /f "delims=" %%f in (user.txt) DO set/a "counter=%counter%+1"
echo %counter% User registriert
echo.
echo.
for /f "delims=" %%f in (user.txt) DO echo %%f
pause>nul
goto MAIN_MENU
REM ---- USER ANZEIGEN ENDE -----


:VIEW_FOLDER
pause>nul
goto MAIN_MENU

:CREATE_LOG
REM Searching for the "Path" parts in cfg.tct
for /f "delims=" %%x in ('findstr /i /b "LogFolderPath" "cfg.txt"') do set "LogFolderPath=%%x"
set "LogFolderPath=%LogFolderPath:LogFolderPath =%"
for /f "delims=" %%y in ('findstr /i /b "LogFileName" "cfg.txt"') do set "LogFileName=%%y"
set "LogFileName=%LogFileName:LogFileName =%" 
for /f "delims=" %%z in ('findstr /i /b "LogFileType" "cfg.txt"') do set "LogFileType=%%z"
set "LogFileType=%LogFileType:LogFileType =%"
set "currentDate=%date:.=%"
set "logFile=%LogFolderPath%%LogFileName%%currentdate%%LogFileType%"
echo.%date% %time:~0,8% ^ %user_name% >> %logFile%
if not "%go%" == "" goto %go%

:INSTALL
call installer.bat
goto MAIN_MENU
goto END

:VARS
for /f "delims=" %%G in ('findstr /i /b "GuestName" "cfg.txt"') do set "GuestName=%%G"
set "GuestName=%GuestName:GuestName =%"
set "user_name=%GuestName%"
set "go="
set "i=0"
goto MAIN_MENU


:SEARCH_STRING
for /f "delims=" %%o in ('findstr /i /b "%str%" "cfg.txt"') do set "row=%%o"
set "s="
set "output=!row:%str% =%s%!"
if not "%go%" == "" goto %go%
goto MAIN_MENU


REM ----- EXIT BEREICH -------
:GOODBYE
cls
echo.
echo.
echo Goodbye \(.____.)/
echo Hamma Geilen Tag noch %user_name%
timeout /t 2 > nul
goto END


:END
exit
REM -- EXIT BEREICH ENDE --