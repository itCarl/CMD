@ECHO OFF
MODE 61, 29
COLOR 0A
rem setting the title to var becams very important later for the progressmeter command
set "title=IP Addresses"
TITLE %title%
setlocal enabledelayedexpansion

if exist temp.txt del temp.txt
if exist temp2.txt del temp2.txt

ECHO ------------------------------------------------------------
ECHO                         IP Addresses
ECHO ------------------------------------------------------------
ECHO.

ARP -a | findstr /i "dynamisch" >> temp.txt
call progressmeter /v 1
for /f "tokens=1 delims=: " %%A in (' findstr /i /n "192.168.178." "temp.txt" ') do set /a "count_of_ips=%%A"
set /a "erg=100/%count_of_ips%"

for /l %%A in (1,1,%count_of_ips%) do (
	set /a "lerg= %%A * %erg%"
	set /a "erg.index[%%A]+=!lerg!"
	)
	
for /f "tokens=1,2 delims=: " %%A in (' findstr /i /n "192.168.178." "temp.txt" ') do (
	ping -a %%B > temp2.txt
	for /f "tokens=5,6 delims= " %%D in (' findstr /i /b "ping" "temp2.txt" ') do if "%%E" == "mit" ( echo ERROR: zeitüberschreitung  %%D ) else ( echo  %%E - %%D )  
	call progressmeter /v !erg.index[%%A]!
)
call progressmeter /v 100

ECHO.

ECHO ------------------------------------------------------------

ARP -a
ECHO.

ECHO ------------------------------------------------------------

call progressmeter /c %title%
if exist temp.txt del temp.txt
if exist temp2.txt del temp2.txt
Pause>NUL
EXIT /b 