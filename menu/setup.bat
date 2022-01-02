@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

:: init ::
set cPath=%~dp0

:start
cls
color 0C
echo.
echo make sure that this file is in a folder :}
timeout /t 2 /nobreak > nul
echo continue... & pause > nul
cls
echo.
echo hi

pause>nul
:end
exit /b