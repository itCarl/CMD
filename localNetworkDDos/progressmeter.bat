@echo off
setlocal enabledelayedexpansion

rem checking parameters
if "%1" == "" ( goto help ) else ( set "param_1=%1")
if "%2" == "" ( goto help ) else ( set "param_2=%2" & set /a "param_2+=0" )
if "%param_1%" == "/c" goto clear 
if "%param_2%" == "0" goto invalid_answer
if %param_2% GEQ 101 goto invalid_answer

if not "%3" == "" goto help

rem redirecting to the functions of different parameter
if "%param_1%" == "/v" goto progressmeter
if "%param_1%" == "/^?" goto help

:help
echo zeigt eine statusanzeige im title mit prozenten an.
echo syntax:  PROGRESSMETER [/P] Prozent ^(0-100^)
echo.
echo.
echo /p	prozent angabe ^(z.B. progressmeter /p 50 ^)
echo		Progress: [^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|              ] 50%%
goto end

:invalid_answer
echo falscher parameter ^> %2
if %param_2% GEQ 101 echo Value ist 0-100 
goto end

:clear
if "%2" == "Default" TITLE %SystemRoot%\system32\cmd.exe
title 
TITLE %2 %3 %4 %5 %6 %7
goto end

:progressmeter
set ProgressPercent=%param_2%
set /A NumBars=%ProgressPercent%/2
set /A NumSpaces=50-%NumBars%

set Meter=
rem building the meter with [ I and <space> ] 
for /L %%A in (%NumBars%,-1,1) do set Meter=!Meter!I
for /L %%A in (%NumSpaces%,-1,1) do set Meter=!Meter! 

TITLE Progress:  [%Meter%]  %ProgressPercent%%%
if errorlevel == 1 set msg_error=progressmeter is unable to change the title

:end
ENDLOCAL