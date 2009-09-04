@echo off
setlocal
call "%~d0%~p0setupenv.bat"

"%BRAINVISA_BUILD%\bin\%1" %2 %3 %4 %5 %6 %7 %8 %9
endlocal