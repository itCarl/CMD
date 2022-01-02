@echo off 

goto VARS

:START
cls

echo Username
set/p "user_name=>"

echo Passwort
set/p "user_pw=>"

set user=%user_name% %user_pw%

for /f "delims=" %%f in (user.txt) DO (
	if "%%f" == "%user%" goto SUCCES
	goto FAIL
	)

:SUCCES
echo du bist eingeloggt :)
pause>nul
goto LOG	
	
:FAIL
set/a fails=%fails% - 1
echo Falsches Passwort oder falscher Username :(
echo Noch %fails% versuche verbleibend

pause>nul
if %fails% == 0 goto KILL
goto START
	
:VARS
set fails=5
set folder=test
goto START	
	
	
:LOG
echo.%date% %time~0,8% ^ %user_name%>> log/log%date%.txt
pause
goto END	
	
:KILL
REM die datei könnte sich hier selber löschen
echo.%date% %time~0,8%>> log/kill%date%.txt
echo KILL
goto END	
	
:END
exit
 