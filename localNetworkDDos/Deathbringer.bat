@echo off
:: setting all that starting stuff ::
call :inIT

::----------------------------------------------::
:: ARP  -a										::
:: Ping -4 -a 192.168.178.xxx -t -l 65000		::
::----------------------------------------------::

call :HEADER

Timeout /T 1 /NoBreak>nul

:: Open IP Address Summary ::
Start "" "network_scanner.bat"

Timeout /T 2 /NoBreak>nul

:START
:: Enter IP Address ::
set /p IP=IP Address:

:: checking if ip exist ::
Ping -4 -a %IP% > nul   
set "msg_error=Invalid ip address"
if errorlevel == 1 goto INVALIDINPUT

:: Enter Buffer Length (max. 65000) ::
set /P Buffer=Buffer Length (max. 65000):
if "%Buffer%" == "" (
	set "Buffer=32"
)
if "%Buffer%" == "0" (
	set "Buffer=32"
)
if %Buffer% GEQ 65001 (
	set "msg_error=max buffer ^= 65000"
	goto INVALIDINPUT
) 

:: Enter Count Of Windows ::
set /p WindowCount=Count Of Windows: 
if "%WindowCount%" == "" (
	set "msg_error=Windows can't be nothing u have to type at least a 1"
	goto INVALIDINPUT
)
if "%WindowCount%" == "0" (
	set "msg_error=Windows can't be 0"
	goto INVALIDINPUT
)
if %WindowCount% GEQ 101 (
	set "msg_error=max Windows ^= 100"
	goto INVALIDINPUT
)

:PinG_START
echo.
echo Starting Ping...
Timeout /T 1 /NoBreak > nul

::------------------------------------------------------------------::
::                           Open Windows							::
::------------------------------------------------------------------::

:: Command for the Windows ::
set Fenster=C:\Windows\System32\Ping -4 -a %IP% -t -l %Buffer%

:: Windows ::
for /L %%I in (1, 1, %WindowCount%) do (
	Start "%%I" %Fenster%
)
::------------------------------------------------------------------::

:: Information after the start ::
Timeout /T 2 /NoBreak > nul
echo Ping is running!
Timeout /T 1 /NoBreak > nul
echo Exit with any key...
Pause > nul

:: Stop Ping ::
echo.
echo Ping will be stopped...
Timeout /T 1 /NoBreak > nul
Taskkill /F -IM PinG.EXE > nul
Timeout /T 1 /NoBreak > nul
echo Ping stopped!
Timeout /T 1 /NoBreak > nul
goto END

:INVALIDINPUT
:: If wrong data was entered ::
Timeout /T 1 /NoBreak>nul
echo.
echo ERROR: %msg_error% 
Timeout /T 1 /NoBreak>nul
echo.
echo restarting program...
for /l %%A in (33,9,100) do (
	call progressmeter /v %%A
	Timeout /T 1 /NoBreak>nul
)
call progressmeter /v 100
Timeout /T 2 /NoBreak>nul
call progressmeter /c %title%
cls
call :HEADER
goto START


:HEADER
echo -----------------------------------------------------------------------------------------
echo                                      Ping IP Address
echo -----------------------------------------------------------------------------------------
echo.
goto :eof

:inIT
set "title=Ping IP Address"
set "msg_error=error"

mode 90, 40
color 0C
title %title%
goto :eof


:: closing sections ::
:END
ECHO This Window will be closed in some seconds...
Timeout /T 2 /NoBreak > nul
Taskkill /F -IM cmd.exe > nul
exit /b