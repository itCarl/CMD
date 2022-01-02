@echo off
setlocal enabledelayedexpansion
rem call myLib INIT
rem --- ALWAYS --- call the function "init" if you are using the library "myLib"

echo.
echo.
echo "Calculater" function example
call myLib Calc 5 * 100 erg
echo 5 ^* 100
echo = %erg%

echo.
echo.
echo "toLower" function example
set "str=C:\Inhalt\mIt\GROSSbucHStaBEN\mit\AA\mittENdrInn "
call myLib toLower %str% ret
echo BEFORE: %str%
echo AFTER: %ret%

echo.
echo.
echo "toUpper" function example
set "str=C:\Inhalt\mIt\klEInbucHStaBEN\mit\aa\mittENdrInn "
call myLib toUpper %str% ret
echo BEFORE: %str%
echo AFTER: %ret%

echo.
echo.
echo "enCrypt" function example
set str="Hier koennte ihre Werbung stehen asd asdas d a dkl fkqw idhweoiajldmiefjergf oder auch ein kleines Strichman oder aber auch koennte man hier irgendein sinVollenStrinHerreinschbenDerAuchSinn macht aber aus test gruenden mache ich das jetzt erstmalNicht"
call myLib enCrypt %str% encString
echo BEFORE: %str%
echo.
echo.

echo enCrypted: %encString%

echo.
echo.
echo "deCrypt" function example - that could take some sec ( but not more then 5)
call myLib deCrypt %encString% abc
echo AFTER: %abc%

echo.
echo.
echo "toCamelCase" function example
set str="alle zehn ziegen ziehen zehn zehnter zucker zum zoo ODERWASISTIHREMEINUNG"
call myLib toCamelCase %str% aff
echo BEFORE: %str%
echo AFTER: %aff%

echo.
echo.
echo %tempFile%

pause>nul
exit