@echo off
setlocal EnableDelayedExpansion enableextensions
title Control Panel
color 0F

:: CHECKING IF ALL NECESSARY FILES ARE EXISTING
:FILE_EXIST_CHECK
if not exist module/_config.txt goto ERROR_CONFIG
if not exist module/modul_checker.bat goto ERROR_CHECKER
if not exist module/_blacklist.txt goto ERROR_BLACKLIST
goto SET_VARS

:: SHOWN MENU AREA + OPTION SETTING TO NAVIGATE INTO THE MODULES
:MENU_BUILDER
cd module
cls
echo.
echo ---------------------------------
echo #
for /f "tokens=2,3 delims= " %%A in (' findstr /b /i "Menu" "_config.txt" ') do echo %hashtag% %space% %space% %%B%bracket% %%A 
echo #
echo %pimmel%
echo ---------------------------------

echo Aktion 
set/p "cho=>"

for /f "tokens=2,3,4 delims= " %%A in (' findstr /n /i "Menu" "_config.txt" ') do set "menu_options[%%B]=%%B" & set "menu_call[%%B]=%%C" & set "menu_count=%%B"
:MENU_OPTIONS
set/a "menu_op_count=%menu_op_count%+1"
if "%cho%" == "!menu_options[%menu_op_count%]!" call !menu_call[%menu_op_count%]!
if "%exit%" == "1" goto SET_VARS

if "%menu_op_count%" == "%menu_count%" goto MENU_BUILDER
goto MENU_OPTIONS

:: SETTING VARS
:SET_VARS
set "hashtag=^#"
set "bracket=^)"
set "space= "
set/a "menu_op_count=0"
set/a "exit=0"
goto MENU_BUILDER

:: ERROR AREA
:ERROR_CONFIG
color 0C
cls
echo.
echo ERROR module/_config.txt NOT FOUND
pause>nul
goto END

:ERROR_CHECKER
color 0C
cls
echo.
echo ERROR module/modul_checker.bat NOT FOUND
pause>nul
goto END

:ERROR_BLACKLIST
color 0C
cls
echo.
echo ERROR module/_blacklist.txt NOT FOUND
pause>nul
goto END

:END
exit 