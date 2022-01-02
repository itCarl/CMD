@echo off 
for %%f in ("user.txt") do echo Last Change: %%~tf
echo.
echo.
for /f "delims=" %%f in (user.txt) DO echo %%f
pause>nul
exit 