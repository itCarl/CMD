@ECHO OFF
:: ******************************************************************
:ProgressMeter
:: 2007_01_10 by rholt
:: core2quad@rogers.com
:: This subroutine displays a progress meter in the titlebar of
:: the current CMD shell window.
::
:: Input: %1 must contain the current progress (0-100)
:: Return: None
:: ******************************************************************
:: Calculate the number of vertical bars then spaces based on the percentage value passed
SETLOCAL ENABLEDELAYEDEXPANSION
set /a "count=1"
:loop
SET ProgressPercent=%count%
SET /A NumBars=%ProgressPercent%/2
SET /A NumSpaces=50-%NumBars%

:: Clear the progress meter image
SET Meter=

:: Build the meter image using vertical bars followed by trailing spaces
:: Note there is a trailing space at the end of the second line below
FOR /L %%A IN (%NumBars%,-1,1) DO SET Meter=!Meter!I
FOR /L %%A IN (%NumSpaces%,-1,1) DO SET Meter=!Meter! 
if %ProgressPercent% GEQ 100 set/a "ProgressPercent=100" 
:: Display the progress meter in the title bar and return to the main program
TITLE Progress:  [%Meter%]  %ProgressPercent%%%
set/a ran=%random% %%2
set/a ran_per=%random% %%21
if %count% GEQ 100 goto :END
timeout /t %ran% > nul
set/a "count+=%ran_per%"
goto loop
:END
cls
echo 100%% Erreicht
echo alles OHNE fehler geladen....
timeout /t 2 > nul
ENDLOCAL
GOTO :EOF
