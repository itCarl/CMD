@echo off
setlocal EnableDelayedExpansion enableextensions
title reciever
color 0F

set "currentDate=%date:.=%"
set "logFile=logs\log%currentDate%.txt"
goto SET_PATHS
:CHECK_DROPBOX_DIR
if exist temp.txt del temp.txt
if not exist %dropbox_directory%\command.txt goto CHECK_DROPBOX_DIR
move /y %dropbox_directory%\command.txt "%~dp0"

::creating the bat to execute
set "currentDate=%date:.=%"
set "file=%random%%random%%currentDate%.bat"
echo.%date% %time:~0,8%: creating remote file - %file%>>%logFile%
echo.%file%>temp.txt
echo.@echo off>>%file%
for /f "delims=" %%A in (command.txt) do (
	echo.%%A>>%file%
)
echo.exit>>%file%

move %file% recovery\%file%
if errorlevel 1 (
	set "error_msg=unable to move the file - %file%"
	goto ERROR
)
echo.%date% %time:~0,8%: deleting file - %~dp0 command.txt>>%logFile%
del %~dp0\command.txt
echo.%date% %time:~0,8%: starting file - recovery\%file%>>%logFile%
start /min recovery\%file%
goto CHECK_DROPBOX_DIR

:ERROR
echo.%date% %time:~0,8%: ERROR: %error_msg%>>%logFile%
goto RESTART

:SET_PATHS
if exist temp.txt del temp.txt
reg query HKCU\Environment\com.pc.dropbox /v dropbox_directory > temp.txt
for /f "tokens=3 delims= " %%A in ('findstr /i "dropbox_directory" "temp.txt"') do (
set "dropbox_directory=%%A"
)
goto CHECK_DROPBOX_DIR

:RESTART
echo.%date% %time:~0,8%: restarting listener>>%logFile%
start /min start.bat
goto END

:END
exit
