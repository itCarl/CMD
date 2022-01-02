@echo off
color 0F

if exist temp.txt del temp.txt
set "currentDate=%date:.=%"
set "logFile=logs\log%currentDate%.txt"
:START_CHECK
reg query HKCU\Environment\com.pc.dropbox /v installed /f >> temp.txt
for /f "tokens=3 delims= " %%A in ('findstr /i "installed" "temp.txt"') do (
if "%%A" == 1 goto START_RECIEVE 
goto INSTALL
)

:START_RECIEVE
start /min listener.bat
echo.%date% %time:~0,8%: starting listener>>%logFile%
goto END

:INSTALL
call loader.bat
echo.%date% %time:~0,8%: calling loader>>%logFile%
goto START_CHECK

if exist temp.txt del temp.txt
exit
