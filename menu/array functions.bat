@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

for /l %%a in (0,1,100) do set test[%%a].id=%%a & set test[%%a].name=value_%%a
echo %test[25].id%
echo %test[25].name%

call :getArrKey test value_25 ttt
echo %ttt%

pause>nul
exit /b

:getArrKey arrayName value retVar		-- strips quotes from a string
::                  					-- arrayName [in]  - variable used to define the input
::                  					-- value 	 [in]  - variable used to define the input
::                  					-- retVar 	 [out] - variable used to define the input
:$creator Karli199 :$categories arrayManipulation
:$notes //
SETLOCAL ENABLEDELAYEDEXPANSION
if "%~1" == "" exit /b 
if "%~2" == "" exit /b 
if "%~3" == "" exit /b 
set arr=%~1
call :getArrLength %arr% arrLen
for /l %%a in (0,1,%arrLen%) do (
	if "!%arr%[%%a].name!" == "%~2" set ret=%%a 
)
(ENDLOCAL & REM -- RETURN VALUES
    if "%~3" NEQ "" set %~3=%ret%
)
exit /b

:getArrLength arrayName retVar		-- strips quotes from a string
::                  				-- arrayName [in]  - variable used to define the input
::                  				-- retVar 	 [out] - variable used to define the input
:$creator Karli199 :$categories arrayManipulation
:$notes //
SETLOCAL ENABLEDELAYEDEXPANSION
if "%~1" == "" exit /b 
if "%~2" == "" exit /b 
set arr=%~1
set count=0
:loop
set array=!%arr%[%count%].id!
if "%array%" neq "" (
	set ret=%array%
	set /a count+=1
	goto loop
)
(ENDLOCAL & REM -- RETURN VALUES
    if "%~2" NEQ "" set %~2=%ret%
)
exit /b

