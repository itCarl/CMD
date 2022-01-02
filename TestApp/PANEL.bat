@echo off
setlocal EnableDelayedExpansion enableextensions
title Control Panel
color 0F
mode con: cols=50 lines=20

:TOP

IF EXIST installer.bat goto INSTALL
goto VARS

:MAIN_MENU
color 0F
cls
echo.
echo Eingelogt als %user_name%
echo ----------------------------------
echo #
echo #	1) login
echo #	2) User anschauen
echo #	3) Ordner
echo #	4) EXIT
echo #
echo ----------------------------------
echo.
echo Aktion
set/p "cho=>"

if %cho% == 1 goto LOGIN
if %cho% == 2 goto VIEW_USER
if %cho% == 3 goto VIEW_FOLDER
if %cho% == 4 goto GOODBYE

goto MAIN_MENU


REM --------- LOGIN BEREICH ---------  
:LOGIN
cls
if not "%user_name%" == "Guest" goto ALREADY_SIGNIN  

echo.
echo Registrieren [Y/N]
set/p "acc=>"

if "%acc%" == "Y" goto REGISTER
if "%acc%" == "y" goto REGISTER
if "%acc%" == "N" goto NIGOL 
if "%acc%" == "n" goto NIGOL
goto LOGIN

:NIGOL
cls
echo Username
set/p "user_name=>"
echo.
echo Passwort
set/p "user_pw=>"

set user=%user_name% %user_pw%

FOR /f "tokens=1,2" %%A in (user.txt) DO (
	if "%%A %%B" == "%user%" goto SUCCES
	goto FAIL	
)

:SUCCES 
set "go="
set "log_msg=eingeloggt"
call :CREATE_LOG

:FAIL
set "str=GuestName"
set "go=FAIL_NAME"
call :SEARCH_IN_CFG
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

timeout /t 3 > nul	
goto LOGIN

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


:REGISTER
color 0F
cls
echo ------- Registriere dich -------
echo.
echo.
echo.
echo Whaele deinen Usernamen
set/p "reg_user_name=>"
set "str=%reg_user_name%"
set "go=REG_USER_CHECK"
call :SEARCH_USER
:REG_USER_CHECK
if not "%output%" == "" goto EXIST_ALREADY 
echo Whaele deinen Passwort
set/p "reg_user_pw=>"
cls
echo.
echo Alles Richtig ^?
echo.
echo.
echo Username: %reg_user_name%
echo Passwort: %reg_user_pw%
echo.
echo [Y]es / [N]o
set/p "reg=>"

if "%reg%" == "Y" goto ADD_USER
if "%reg%" == "y" goto ADD_USER
if "%reg%" == "N" goto REGISTER
if "%reg%" == "n" goto REGISTER
goto MAIN_MENU

:ADD_USER
cls
set "new_user=%reg_user_name% %reg_user_pw%"
echo.%new_user%>> user.txt
set "user_name=%reg_user_name%"
echo.
echo Glueckwunch %user_name% du bist jetzt Mitglied :)
timeout /t 4 > nul
set "log_msg=registriert"
set "go="
 pause > nul
call :CREATE_LOG

:EXIST_ALREADY
color 0C
cls
echo. 
echo Es existiert bereits ein User mit diesem Namen !
echo Suchen sie sich einen anderen aus.

timeout /t 5 > nul
goto REGISTER


REM ---- LOGIN BEREICH ENDE ------ 


REM --------- USER ANZEIGEN --------- 
:VIEW_USER
color 0F
cls
set "str=AdminAcc"
set "go=VUSER_CHECK_ADMIN"
call :SEARCH_IN_CFG
:VUSER_CHECK_ADMIN
if not "%user_name%" == "%output%" goto GUEST_ERROR
for %%f in ("user.txt") do echo Last Change: %%~tf 
for /f "delims=:" %%f in ('findstr /N .* "user.txt"') DO set "user_count=%%f"
echo %user_count% User registriert
echo.
echo.
for /f "delims=" %%f in (user.txt) DO echo %%f
pause > nul
goto MAIN_MENU


REM ---- USER ANZEIGEN ENDE -----


REM ---- ORDNER (MENU) BEREICH -----

:VIEW_FOLDER
color 0F
cls
set "str=GuestAcc"
set "go=VFOLDER_CHECK_GUEST"
call :SEARCH_IN_CFG
:VFOLDER_CHECK_GUEST
if "%user_name%" == "%output%" goto GUEST_ERROR


REM ------ DEMO ORDNER ------
:DEMO_FOLDER
cls
echo.
echo ----------------------------------
echo #
for /f "tokens=2,3 delims= " %%A in ('findstr /i /b "DemoMenu" "cfg.txt"') do (
echo %hashtag%  %%B%klamma% %%A 
)
echo #
echo ----------------------------------
echo.
echo Aktion
set/p "cho=>"

if %cho% == 1 goto DEMO_FOlDER_DESC
if %cho% == 2 goto DEMO_FOLDER_OPEN_CLOSE
if %cho% == 3 goto DEMO_FOLDER_SETTINGS
if %cho% == 4 goto BACK_TO_MAIN_MENU
goto DEMO_FOLDER


REM ------ DEMO ENDE ------


pause>nul
goto MAIN_MENU
REM ---- ORDNER (MENU) BEREICH -----


:CREATE_LOG
REM Searching for the "Path" parts in cfg.tct
for /f "delims=" %%x in ('findstr /i /b "LogFolderPath" "cfg.txt"') do set "LogFolderPath=%%x"
set "LogFolderPath=%LogFolderPath:LogFolderPath =%"
for /f "delims=" %%y in ('findstr /i /b "LogFileName" "cfg.txt"') do set "LogFileName=%%y"
set "LogFileName=%LogFileName:LogFileName =%" 
for /f "delims=" %%z in ('findstr /i /b "LogFileType" "cfg.txt"') do set "LogFileType=%%z"
if not "%log_msg%" == "" set "log_msg=- %log_msg%"

set "LogFileType=%LogFileType:LogFileType =%"
set "currentDate=%date:.=%"
set "logFile=%LogFolderPath%%LogFileName%%currentdate%%LogFileType%"
echo.%date% %time:~0,8% ^ %user_name% %log_msg% >> %logFile%
if not "%go%" == "" goto %go% 
goto MAIN_MENU

:GUEST_ERROR
color 0C
echo.
echo.
echo ZUGRIFF VERWEIGERT ^^!
timeout /t 2 > nul
goto MAIN_MENU

:INSTALL
call installer.bat
goto MAIN_MENU


REM ------ Used to DeBug Vars ------
:VARS
for /f "delims=" %%q in ('findstr /i /b "GuestAcc" "cfg.txt"') do set "GuestName=%%q"
set "user_name=%GuestName:GuestAcc =%" 
set "i=0"
set "go="
goto MAIN_MENU
REM --------------------------------------------

:SEARCH_IN_CFG
for /f "delims=" %%o in ('findstr /i /b "%str%" "cfg.txt"') do set "row=%%o"
set "s="
set "output=!row:%str% =%s%!"
if not "%go%" == "" goto %go% 
goto MAIN_MENU

:SEARCH_USER
for /f "delims=" %%o in ('findstr /i /b /r "%str%" "user.txt"') do set "row=%%o"
set "output=%row%"
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