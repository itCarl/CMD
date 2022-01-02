@echo off 

echo User name
set/p "user_name=>" 

echo User passwort
set/p "user_pw=>"

echo.
echo.
echo %user_name%
echo %user_pw%

echo.%user_name% %user_pw%>> user.txt

pause>nul
exit 