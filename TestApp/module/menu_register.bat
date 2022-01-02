@echo off
setlocal EnableDelayedExpansion EnableExtensions

set/a "autoset=1"
set "config=_config.txt"
set "display_name=Login"
set/a "menu_index=1"

REM SEARCHING THE CONFIG FILE
for /f "delims= " %%A in ('dir /b /s ^| find /i "_config.txt" ') do (
	set "config_path=%%A"
)



pause>nul