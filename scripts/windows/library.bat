@echo off
setlocal
set procedure=:%1
shift
REM call the procedure in argument
goto %procedure%

REM #------------------------------------------------------------------------------
REM # Procedures definfition
REM #------------------------------------------------------------------------------

:i2bm_pathvar_normalize
REM #------------------------------------------------------------------------------
REM # Normalize path variable by removing ;
REM #------------------------------------------------------------------------------
setlocal
set result="%~1"
:loop
set preceding_result=%result%
set result=%result:;;=;%
if not %preceding_result% equ %result% (
	goto :loop
)
if "%result:~1,-1%" equ "" (
  goto :endi2bm_pathvar_normalize
)
if "%result:~-2,-1%" equ ";" (
  set result="%result:~1,-2%"
)
if "%result:~1,-1%" equ "" (
  goto :endi2bm_pathvar_normalize
)
if "%result:~1,1%" equ ";" (
  set result="%result:~2,-1%"
)
:endi2bm_pathvar_normalize
endlocal & set result=%result%
goto :end

:i2bm_pathvar_remove
REM #------------------------------------------------------------------------------
REM # Remove value from path variable
REM #------------------------------------------------------------------------------
setlocal
call :i2bm_pathvar_normalize "%~1"
set path=%result:~1,-1%;
call :i2bm_pathvar_normalize "%~2"
set value=%result:~1,-1%;
call set result=%%path:%value%=%%
call :i2bm_pathvar_normalize "%result%"
endlocal & set result=%result%
goto :end

:i2bm_pathvar_append
REM #------------------------------------------------------------------------------
REM # Append _value to _path variable
REM #------------------------------------------------------------------------------
setlocal
set path="%~1"
set value="%~2"
call :i2bm_pathvar_remove %path% %value%
call :i2bm_pathvar_normalize "%result:~1,-1%;%value:~1,-1%"
endlocal & set result=%result%
goto :end

:i2bm_pathvar_prepend
REM #------------------------------------------------------------------------------
REM # Prepend _value to _path variable
REM #------------------------------------------------------------------------------
setlocal
set path="%~1"
set value="%~2"
call :i2bm_pathvar_remove %path% %value%
call :i2bm_pathvar_normalize "%value:~1,-1%;%result:~1,-1%"
endlocal & set result=%result%
goto :end

:i2bm_pathvar_find
REM #------------------------------------------------------------------------------
REM # get directory or file in path variable
REM #------------------------------------------------------------------------------
setlocal
set path="%~1"
set find="%~2"
set append="%~3"
call :i2bm_pathvar_normalize %path%
set escapedpath=%result:;=" "%
set result=
for %%i in (%escapedpath%) do (
  if not defined result (
    if exist "%%~i\%find:~1,-1%" (
      if %append% neq "false" (
        set result="%%~i\%find:~1,-1%"
      )
      if %append% equ "false" (
        set result="%%~i"
      )
    )
  )
)
if not defined result (
  set result=""
)
endlocal & set result=%result%
goto :end

:i2bm_get_pythonexedir
REM #------------------------------------------------------------------------------
REM # get python executable directory
REM #------------------------------------------------------------------------------
setlocal
call :i2bm_pathvar_find "%PATH%" "python.exe" "false"
endlocal & set result=%result%
goto :end

:i2bm_get_osid
REM #------------------------------------------------------------------------------
REM # get os id
REM #------------------------------------------------------------------------------
setlocal
call :i2bm_pathvar_find "%BRAINVISA_SOURCES%" "development\build-config\trunk\systemIdentification"
set scriptpath=%result%
set result=""
for /F "usebackq delims==" %%i in (`python.exe %scriptpath%`) do (
  set result=%%i
)
endlocal & set result=%result%
goto :end

:end
endlocal & set result=%result%