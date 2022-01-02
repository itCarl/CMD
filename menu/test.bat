@echo off
SETLOCAL ENABLEDELAYEDEXPANSION
:: TODO
:: make menu center option
:: clean the hole script
:: make it more efficent and faster

:: internal var settings ::
if exist config.bat ( call config.bat ) else ( call :createCfg )
set ssize=%screen_size%
set yPos=%default_y_pos%
set e_k=wsd
set fileDate=%date:.=%
set /a count=0
set /a c=0
set /a co=0
mode con cols=%ssize% lines=20 
call :getMenuLength
call :createMenuFiles
call :getLongestMenuOption
call :generateHead
call :generateMenuBody


:: the main part of building the menu
:menu
if "%backupMenu%" == "1" call :backupMenu
set /a cv=0
cls
echo.
rem echo  %menuLength%
rem echo  %dyPos%
rem echo  %ypos%
rem echo  %bla%

:: Header
echo  %head_top_line% 
echo  %head_title%
echo  %head_bottom_line%

:: Body
for /l %%a in (1,1,%menuLength%) do (
	set select= 
	if "%yPos%" == "%%a" set select=%selector%
	echo  º ^[ !select! ^] !menu_body_line[%%a]!
	set select= 
)

:: Footer
echo  %footer_line%

:: Navigation
choice /c:%e_k% /n
if errorlevel 3 goto select_menu
if errorlevel 2 goto down
if errorlevel 1 goto up
exit /b

:: Up & down Navigation
:up
if "%yPos%" LEQ "1" ( set "yPos=%menuLength%" ) else ( set /a "yPos-=1" & set bla=up)
goto menu

:down
if %yPos% GEQ %menuLength% ( set "yPos=1" ) else ( set dyPos=%yPos% & set /a "yPos+=1" & set bla=down )
goto menu



::-----------------------------------------------------------
:: helper functions follow below here
::-----------------------------------------------------------

:generateHead&Footer
set /a ngre=%gre%+7
for /l %%a in (0,1,%ngre%) do set line=Í!line!

set /a size=%ngre%-1
set s=-Menu-   
for /L %%# in (1,2,!size!) do if "!s:~%size%,1!" == "" set "s=  !s! "
set s=º !s:~1,%size%! º

set head_top_line=É!line!»
set head_bottom_line=Ì!line!¹
set footer_line=È!line!¼
set head_title=!s!

exit /b

:generateMenuBody
set ghgh[%count%]=
set select= 
set /a count+=1
if "!menu[%count%]!" == "" goto menu
if "%yPos%" == "%count%" set select=%selector%
set "test1=^[ %select% ^] !menu[%count%]!"
call :strLen "%test1%" len
set /a bla=%ngre% - %len%
set /a bla-=2
for /l %%a in (0,1,%bla%) do set ghgh[%count%]= !ghgh[%count%]!
set menu_body_line[%count%]=!menu[%count%]!!ghgh[%count%]! º
goto generateMenuBody
exit /b


:createMenuFiles
call :toLower %menuFileFolder% menuFileFolder
if not exist %menuFileFolder% md %menuFileFolder%
set sampleFileName=%menuFileFolder%/sample.txt
if %sampleFile% == 1 call :createSampleFile 
for /l %%a in (1,1,%menuLength%) do (
    call :toLower "!menu[%%a]!" ret_menu[%%a]
	set menuFileName[%%a]=%menuFileFolder%/!ret_menu[%%a]: =_!.bat
	if not exist !menuFileName[%%a]! (
		if %sampleFile% == 1 (
			for /f "delims=" %%b in (%sampleFileName%) do echo.%%b>> !menuFileName[%%a]!	
		) else ( 
			echo.@echo off>>!menuFileName[%%a]!
		)
	)
)
exit /b

:createSampleFile
set sampleFileName=%menuFileFolder%/sample.txt
if exist %sampleFileName% exit /b

( echo.@echo off
  echo.title example for a menu file
  echo.
  echo.echo Hello World !
  echo.
  echo.pause
  echo.exit /b ) > %sampleFileName%

exit /b

:createCfg
( echo.set selector=@
  echo.set enter_key=d
  echo.set default_y_pos=1
  echo.set backupMenu=1
  echo.set screen_size=50
  echo.set menu[1]=Start games
  echo.set menu[2]=Load game
  echo.set menu[3]=credits
  echo.set menu[4]=help
  echo.set menu[5]=extras
  echo.set menu[6]=Help
  echo.rem ---------------------------------------------------
  echo.rem DONT CHANGE ANY SHIT THATS BELOW THIS LINE !
  echo.
  echo.set menuFileFolder=Files
  echo.set sampleFile=1 
  ) > config.bat
  
timeout /t 1 /nobreak > nul
call config.bat  
exit /b

:backupMenu
if not exist backups md backups
set backupFile=backups/backup%fileDate%.bat
if exist %backupFile% exit /b
if "%backupFileName%" == "" set backupFileName=placeholder
for /l %%a in (1,1,%menuLength%) do (
	echo.set menu_body_line[%%a]=!menu_body_line[%%a]!>> %backupFile%
)
if %backupFile% neq %backupFileName% echo.set backupFileName=%backupFile%>> config.bat
exit /b

:select_menu
cls
set file=!menuFileName[%yPos%]!
call %file%
goto menu

:getMenuLength
set /a c+=1
set menuArr=!menu[%c%]!
if "%menuArr%" NEQ "" ( goto getMenuLength )
set /a menuLength=%c%-1
exit /b

:getLongestMenuOption
for /l %%a in (1,1,%menuLength%) do (
	for /l %%b in (0,1,50) do if "!menu[%%a]:~%%b,1!" NEQ "" set /a menuLen[%%a]=%%b + 1
)
set gr1=0
for /l %%a in (1,1,%menuLength%) do (
	if /i !menuLen[%%a]! GTR !gr1! (
		set gr1=!menuLen[%%a]!
		)
)
set gre=%gr1%
exit /b

:strLen str ret		-- returns the length of a string by "Brute forcing" the string
::                 	-- str [in]  - variable used to define the input
::                  -- ret [out] - variable to be used to return the string
:$creator Karli199 :$categories stringManipulation
:$notes //
SETLOCAL ENABLEDELAYEDEXPANSION 
set /a "counta=0"
:_loop-strLen
set /a "counta+=1"
set "string=%~1"
set "str=!string:~%counta%,1!"
if not "!str!" == "" goto _loop-strLen
set "ret=%counta%"

(ENDLOCAL & REM RETURN VALUES
    if "%~2" NEQ "" set /a %~2=%ret%
)
exit /b

:toLower str ret		-- converts uppercase character to lowercase
::                 		-- str [in]  - variable used to define the input
::                 		-- ret [out] - variable to be used to return the string
:$creator Karli199 :$categories stringManipulation
:$notes //  
SETLOCAL ENABLEDELAYEDEXPANSION
if "%~1" == "" exit /b
set out="%~1"
for %%a in ( "A=a" "B=b" "C=c" "D=d" "E=e" "F=f" "G=g" "H=h" "I=i" 
			 "J=j" "K=k" "L=l" "M=m" "N=n" "O=o" "P=p" "Q=q" "R=r" 
			 "S=s" "T=t" "U=u" "V=v" "W=w" "X=x" "Y=y" "Z=z" ) do ( 
    set "out=!out:%%~a!" 
)
call :trim %out% ret

(ENDLOCAL & REM -- RETURN VALUES
    if "%~2" NEQ "" set %~2=%ret%
)
exit /b

:trim str ret		-- strips quotes from a string
::                  -- str [in]  - variable used to define the input
::                  -- ret [out] - variable to be used to return the string
:$creator Karli199 :$categories stringManipulation
:$notes this function is used to writes into the logFile. dont forget to use "" around that string
SETLOCAL ENABLEDELAYEDEXPANSION
if "%~1" == "" exit /b 
set "str=%~1"
for /f "useback tokens=*" %%a in ('%str%') do set ret=%%~a

(ENDLOCAL & REM -- RETURN VALUES
    if "%~2" NEQ "" set %~2=%ret%
)
exit /b

