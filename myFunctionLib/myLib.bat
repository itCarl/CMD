@echo off
call :INIT

rem :: actual starting point ::
:START
if "%~1" == "enCrypt" call :%~1 %~2 %~3 & goto END
if "%~1" == "deCrypt" call :%~1 %~2 %~3 & goto END
call :%~1 %~2 %~3 %~4 %~5 %~6 %~7 %~8 %~9 %~10 %~11
goto END


:toUpper str ret		-- converts lowercase character to Uppercase
::                 		-- str [in]  - variable used to define the input
::                 		-- ret [out] - variable to be used to return the string
:$creator Karli199 :$categories stringManipulation
:$notes //   
SETLOCAL ENABLEDELAYEDEXPANSION
if "%~1" == "" exit /b
set out="%~1"
for %%a in ( "a=A" "b=B" "c=C" "d=D" "e=E" "f=F" "g=G" "h=H" "i=I" 
			 "j=J" "k=K" "l=L" "m=M" "n=N" "o=O" "p=P" "q=Q" "r=R" 
			 "s=S" "t=T" "u=U" "v=V" "w=W" "x=X" "y=Y" "z=Z" ) do ( 
    set "out=!out:%%~a!" 
)
call :trim %out% ret

(ENDLOCAL & REM -- RETURN VALUES
    if "%~2" NEQ "" set %~2=%ret%
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

:enCrypt str result		-- converts human readable symbols to crypted data
::                 		-- str [in]  - variable used to define the input
::                 		-- ret [out] - variable to be used to return the string
:$creator Karli199 :$categories stringManipulation
:$notes //  
SETLOCAL ENABLEDELAYEDEXPANSION
if "%~1" == "" exit /b
set str="%~1"

rem setting the hole string to low case to make sure that everything is working fine
call :toLower %str% out
for %%a in ( "a=08" "b=09" "c=10" "d=11" "e=12" "f=13" "g=14" "h=15" "i=16" 
			 "j=17" "k=18" "l=19" "m=20" "n=21" "o=22" "p=23" "q=24" "r=25" 
			 "s=26" "t=27" "u=28" "v=29" "w=30" "x=31" "y=32" "z=33" "\=99" " =55") do ( 
    set "out=!out:%%~a!" 
)
call :trim %out% ret

(ENDLOCAL & REM -- RETURN VALUES
    if "%~2" NEQ "" set %~2=%ret%
)
exit /b

:deCrypt str ret		-- converts encrypted data into human readable symbols
::                 		-- str [in]  - variable used to define the input
::                 		-- ret [out] - variable to be used to return the string
:$creator Karli199 :$categories stringManipulation
:$notes //  
SETLOCAL ENABLEDELAYEDEXPANSION
if "%~1" == "" exit /b 
set "str=%~1"
set "ret="
call :strLen2 %str% len & rem using the fast string length function to speed it up a bit
for /l %%A in (0,2,%len%) do  (
	call :_deCrypt_Sub !str:~%%A,2! out
	set "ret=!ret!!out!"
)
(ENDLOCAL & REM -- RETURN VALUES
    if "%~2" NEQ "" set %~2=%ret%
)
exit /b

:_deCrypt_Sub str ret		-- The sub function of deCrypt   !!! DONT TOUCH OR CALL IT !!!
::          				-- str [in]  - variable string variable to be converted
::          				-- ret [out] - variable to be used to return the result
:$creator Karli199 :$categories stringManipulation
:$notes // 
SETLOCAL ENABLEDELAYEDEXPANSION
call :toLower %~1 lowCase
set "ret=%lowCase%"
for %%a in ( "08=a" "09=b" "10=c" "11=d" "12=e" "13=f" "14=g" "15=h" "16=i" 
			 "17=j" "18=k" "19=l" "20=m" "21=n" "22=o" "23=p" "24=q" "25=r" 
			 "26=s" "27=t" "28=u" "29=v" "30=w" "31=x" "32=y" "33=z" "99=\" 
			 "55= "	) do ( 
    set "ret=!ret:%%~a!" 
)

(ENDLOCAL & REM -- RETURN VALUES
    if "%~2" NEQ "" set %~2=%ret%
)
exit /b

:strLen str ret		-- returns the length of a string by "Brute forcing" the string
::                 	-- str [in]  - variable used to define the input
::                  -- ret [out] - variable to be used to return the string
:$creator Karli199 :$categories stringManipulation
:$notes //
SETLOCAL ENABLEDELAYEDEXPANSION
if "%~1" == "" exit /b 
set /a "count+=0"
:_loop-strLen
set /a "count+=1"
set "string=%~1"
set "str=!string:~%count%,1!"
if not "!str!" == "" goto _loop-strLen
set "ret=%count%"

(ENDLOCAL & REM RETURN VALUES
    if "%~2" NEQ "" set /a %~2=%count%
)
exit /b

:strLen2 str ret		-- returns the length of a string by using the file size of a temp file (minus 2 bytes)
::                 		-- str [in]  - variable used to define the input
::                  	-- ret [out] - variable to be used to return the string
:$creator Karli199 :$categories stringManipulation
:$notes //
SETLOCAL ENABLEDELAYEDEXPANSION
if "%~1" == "" exit /b 
call :temp tempFile
set "str=%~1"
echo !str!>"%tempFile%"
for %%F in ("%tempFile%") do set /a ret=%%~zF-2 & rem thats where the magic happends with "file size" minus 2
rem timeout /t 1 /nobreak > nul
del "%tempFile%"

(ENDLOCAL & REM -- RETURN VALUES
    if "%~2" NEQ "" set %~2=%ret%
)
exit /b

:temp ret		-- creating a unique temp file string to avoid any collisions with other temp files
::              -- ret [out] - variable to be used to return the string
:$creator Karli199 :$categories temp, fileManipulation
:$notes this function is used to creates a unique temp file string
SETLOCAL
if "%~1" == "" exit /b 
if not exist %_library.tempFolder% md %_library.tempFolder%

rem formatting the date without "."
set "currentDate=%date:.=%"
set "ret=%_library.tempFolder%\temp%currentDate%%random%.txt"

(ENDLOCAL & REM -- RETURN VALUES
    if "%~1" NEQ "" set %~1=%ret%
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


:writeLog str		-- writing a message into the log file
::               	-- str [in]  - variable used to define the input
:$creator Karli199 :$categories log, fileManipulation
:$notes this function is used to writes into the logFile. dont forget to use "" around that string
SETLOCAL 
if "%~1" == "" exit /b

rem formatting the date without "."
set "cdate=%date:.=%"
set "logFile=%_library.logFolder%\log%cdate%.txt"
if not exist %logFile% call :createLog logFile

echo. [%date% ~ %time:~0,8%]: %~1 >> %logFile%

ENDLOCAL
exit /b

:createLog ret			-- returns the log file name
::               		-- ret [out] - variable to be used to return the string
:$creator Karli199 :$categories log, fileManipulation
:$notes this function is used to creates a log file name to avoid any conflicts
SETLOCAL
if "%~1" == "" exit /b
rem here is one of the important things to have have the "init" function configured in the right way
rem if the log folder don't exist already then it will created
if not exist %_library.logFolder% md %_library.logFolder%

rem formatting the date without "."
set "cdate=%date:.=%"
set "logFile=%_library.logFolder%\log%cdate%.txt"
rem creating the log file 
if not exist %logFile% echo. > %logFile%

(ENDLOCAL & REM RETURN VALUES
    if "%~1" NEQ "" set %~1=%logFile%
)
exit /b

:getFunctions ret		-- returns a comma separated list of all functions in this Library
::               		-- str [in]  - variable used to define the input
::               		-- ret [out] - variable to be used to return the string
:$creator Karli199 :$categories helper
:$notes its a useful function to display all functions that exist in the library
SETLOCAL ENABLEDELAYEDEXPANSION
if "%~1" == "" exit /b
set ret=
for /f "delims=: " %%a in ('"findstr "^^:[a-z].*--" "%~f0" "') do call set ret=!ret! %%a,

(ENDLOCAL & REM RETURN VALUES
    if "%~1" NEQ "" set %~1=%ret%
)
exit /b

:toCamelCase str ret		-- converts the input to a camel case string
::               			-- str [in]  - variable used to define the input
::               			-- ret [out] - variable to be used to return the string
:$creator Karli199 :$categories stringManipulation
:$notes //
SETLOCAL ENABLEDELAYEDEXPANSION
if "%~1" == "" exit /b
rem make all lower case
set "str=%~1"
for %%a in ("A=a" "B=b" "C=c" "D=d" "E=e" "F=f" "G=g" "H=h" "I=i"
            "J=j" "K=k" "L=l" "M=m" "N=n" "O=o" "P=p" "Q=q" "R=r"
            "S=s" "T=t" "U=u" "V=v" "W=w" "X=x" "Y=y" "Z=z"
            "Ä=ä" "Ö=ö" "Ü=ü") do (
    set "str=!str:%%~a!"
)
REM make first character upper case
for %%a in (" a=A" " b=B" " c=C" " d=D" " e=E" " f=F" " g=G" " h=H" " i=I"
            " j=J" " k=K" " l=L" " m=M" " n=N" " o=O" " p=P" " q=Q" " r=R"
            " s=S" " t=T" " u=U" " v=V" " w=W" " x=X" " y=Y" " z=Z"
            " ä=Ä" " ö=Ö" " ü=Ü") do (
	set "str=!str:%%~a!"
)
(ENDLOCAL & REM RETURN VALUES
    if "%~2" NEQ "" set "%~2=%str%"
)
exit /b


rem :: if the file gets initialized then it will load that first ::
:INIT
rem :: setting up some vars ::
set "_library.version=0.1.6.0"
set "_library.tempFolder=temp"
set "_library.logFolder=log"
set "_library.full_path=%~dp0"
set "_library.msg_success=success"
set "_library.msg_info=info"
set "_library.msg_error=error"
call :createLog logFile
set "_library.logFile=%logFile%"
rem ----- NOTES ------
rem 
rem always use "" if the function wants string it doesnt hurt your pc dont worry <3

rem :: seting up the "header" of file ::
rem example: setlocal enabledelayedexpansion
exit /b

rem :: Ending section ::
:END
endlocal
exit /b