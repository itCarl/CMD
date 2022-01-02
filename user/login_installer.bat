@echo off 
title Installer

REM  ----- erstellen der txt -----
if NOT EXIST %folder% md %folder%
if NOT EXIST %folder%/user.txt echo.Demo 1234>>%folder%/user.txt
if NOT EXIST %folder%/%log_folder% md %folder%/%log_folder%
REM  -----------------------------

REM  ----- erstellen der login.bat -----
REM  -----------------------------------

REM  ----- erstellen der add_user.bat -----
REM  --------------------------------------

REM  ----- erstellen der view_user.bat -----
REM  ---------------------------------------

REM  ----- löschen der txt und dieser datei -----
REM  --------------------------------------------

:END
echo.
echo.
echo.
echo Instalation Abgeschlossen :)
pause>nul
exit
