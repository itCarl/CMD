@echo off 

call :menuBuilder menu.cfg

pause > nul
exit /b

:menuBuilder cfgFile		-- asdasdasda
::                 			-- str [in]  - variable used to define the input
::                 			 -- ret [out] - variable to be used to return the string
:$creator Karli199 :$categories //
:$notes //
SETLOCAL ENABLEDELAYEDEXPANSION
if "%~1" == "" exit /b
set "cfgFile=%~1"
set "defaultPos=1"
set "yPos=%defaultPos%"
:refresh
cls
for /f "tokens=2 delims=: " %%a in (' findstr /i "selector" "%cfgFile%" ') do set "selector=%%a"

for /f "tokens=2,3 delims= " %%a in (' findstr /i "menu" "%cfgFile%" ') do (
set "sel="
if "%%b" == "%yPos%" set "sel=%selector%"
echo !sel!		%%b^) %%a 
)

choice /c:dws /n
if "%errorlevel%" == "1" set "choice=yPos"
if "%errorlevel%" == "2" set /a yPos-=1 & goto refresh
if "%errorlevel%" == "3" set /a yPos+=1 & goto refresh
(ENDLOCAL & REM RETURN VALUES
)
exit /b