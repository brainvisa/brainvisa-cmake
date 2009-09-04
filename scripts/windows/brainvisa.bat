@echo off
setlocal
call "%~d0%~p0setupenv.bat"

python.exe -S -OO "%BRAINVISA_BUILD%\brainvisa\neuro.py" %1 %2 %3 %4 %5 %6 %7 %8 %9
endlocal