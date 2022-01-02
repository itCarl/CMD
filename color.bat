@echo off
setlocal

call :Echo.Color.Init
call :Echo.Color 2f ^^^^^^^!

goto main

:Echo.Color %1=Color %2=Str [%3=/n]
setlocal enableDelayedExpansion
set "str=%~2"
:Echo.Color.2
:# Replace path separators in the string, so that the final path still refers to the current path.
set "str=a%ECHO.DEL%!str:\=a%ECHO.DEL%\..\%ECHO.DEL%%ECHO.DEL%%ECHO.DEL%!"
set "str=!str:/=a%ECHO.DEL%/..\%ECHO.DEL%%ECHO.DEL%%ECHO.DEL%!"
set "str=!str:"=\"!"
:# Go to the script directory and search for the trailing -
pushd "%ECHO.DIR%"
findstr /p /r /a:%~1 "^^-" "!str!\..\!ECHO.FILE!" nul
popd
:# Remove the name of this script from the output. (Dependant on its length.)
for /l %%n in (1,1,12) do if not "!ECHO.FILE:~%%n!"=="" <nul set /p "=%ECHO.DEL%"
:# Remove the other unwanted characters "\..\: -"
<nul set /p "=%ECHO.DEL%%ECHO.DEL%%ECHO.DEL%%ECHO.DEL%%ECHO.DEL%%ECHO.DEL%%ECHO.DEL%"
:# Append the optional CRLF
if not "%~3"=="" echo.
endlocal & goto :eof

:Echo.Color.Var %1=Color %2=StrVar [%3=/n]
if not defined %~2 goto :eof
setlocal enableDelayedExpansion
set "str=!%~2!"
goto :Echo.Color.2

:Echo.Color.Init
set "ECHO.COLOR=call :Echo.Color"
set "ECHO.DIR=%~dp0"
set "ECHO.FILE=%~nx0"
set "ECHO.FULL=%ECHO.DIR%%ECHO.FILE%"
:# Use prompt to store a backspace into a variable. (Actually backspace+space+backspace)
for /F "tokens=1 delims=#" %%a in ('"prompt #$H# & echo on & for %%b in (1) do rem"') do set "ECHO.DEL=%%a"
goto :eof

:main
call :Echo.Color 0a "a"
call :Echo.Color 0b "b"
set "txt=^" & call :Echo.Color.Var 0c txt
call :Echo.Color 0d "<"
call :Echo.Color 0e ">"
call :Echo.Color 0f "&"
call :Echo.Color 1a "|"
call :Echo.Color 1b " "
call :Echo.Color 1c "%%%%"
call :Echo.Color 1d ^"""
call :Echo.Color 1e "*"
call :Echo.Color 1f "?"
:# call :Echo.Color 2a "!"
call :Echo.Color 2b "."
call :Echo.Color 2c ".."
call :Echo.Color 2d "/"
call :Echo.Color 2e "\"
call :Echo.Color 2f "q:" /n
echo(
set complex="c:\hello world!/.\..\\a//^<%%>&|!" /^^^<%%^>^&^|!\
call :Echo.Color.Var 74 complex /n
pause>nul
exit /b

:# The following line must be last and not end by a CRLF.
-