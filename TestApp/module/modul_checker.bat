@echo off
setlocal EnableDelayedExpansion EnableExtensions
title Control Panel
color 0F

set "user_name=Max"
set "user_file=test.txt"
set "temp_blacklist_file=t_blacklist.txt"
set "temp_file=temp.txt"
set "modul_name=ABC.bat"
set "indecator=#"
set "succes_msg=File erfolgreich convertiert"
set/a "check_counter=0"
if EXIST %temp_file% del %temp_file%
if EXIST %temp_blacklist_file% del %temp_blacklist_file%

:GET_FILE_INFO
for /f "tokens=1-20 delims== " %%A in (%user_file%) do (
	echo.%indecator% %%A %%B %%C %%D %%F %%G %%H %%I %%J %%K %%L %%M %%N %%O %%P %%Q %%R %%S %%T >>%temp_file%
)
for /f "tokens=1 delims=:# " %%A in ('findstr /i /b /n "%indecator%" "%temp_file%"') do (
	set "line_count=%%A"
)
goto SETUP_FILE_CHECK


:SETUP_FILE_CHECK
for /f "tokens=1,2 delims== " %%A in (blacklist.txt) do (
	echo.%indecator% %%A %%B>>%temp_blacklist_file%
)
for /f "tokens=1,2 delims=:# " %%A in ('findstr /i /b /n "%indecator%" "%temp_blacklist_file%"') do (
	set "blacklist[%%A]=%%B"
	set/a "blacklist_count=%%A"
)
goto CHECK_FILE

:CHECK_FILE
set/a "check_counter=%check_counter% + 1"
set "search_string=!blacklist[%check_counter%]!"
for /f "tokens=1-20 delims=:# " %%A in ('findstr /i /n "%search_string%" "%temp_file%"') do (
	set "check_line[%%A]=1"
	set "line[%%A]=%%B %%C %%D %%F %%G %%H %%I %%J %%K %%L %%M %%N %%O %%P %%Q %%R %%S %%T"
)
if "%blacklist_count%" == "%check_counter%" goto S
goto CHECK_FILE
:S
set/a "check_counter=0"
:SHOW_CHECK_RESULT
set/a "check_counter=%check_counter% + 1"
if "!check_line[%check_counter%]!" == "1" echo ERROR at line %check_counter%
if "!check_line[%check_counter%]!" == "1" set "error=1"
if not "%line_count%" == "%check_counter%" goto SHOW_CHECK_RESULT
if "%error%" == "1" goto FILE_CHECK_ERROR
goto FILE_CHECK_SUCCES

:FILE_CHECK_ERROR
pause>nul
goto END


:FILE_CHECK_SUCCES
echo %succes_msg%
for /f "tokens=1-20 delims== " %%A in (%user_file%) do (
	echo.%%A %%B %%C %%D %%F %%G %%H %%I %%J %%K %%L %%M %%N %%O %%P %%Q %%R %%S %%T >>%user_name%%modul_name%
)
pause>nul
goto END


:END
if EXIST %temp_file% del %temp_file%
if EXIST %temp_blacklist_file% del %temp_blacklist_file%
exit