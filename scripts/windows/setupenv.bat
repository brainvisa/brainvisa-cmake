@echo off

REM #------------------------------------------------------------------------------
REM # set local variables
REM #------------------------------------------------------------------------------
if not defined BRAINVISA_BUILD (
if not defined HOME (
  set HOME=%HOMEDRIVE%%HOMEPATH%
)

if not defined BRAINVISA_SOURCES (
  set BRAINVISA_SOURCES=%HOME%
)

if not defined SOMA_VERSION (
  set SOMA_VERSION=stable
)

if not defined SOMA_MODE (
  set SOMA_MODE=release
)


call "%~d0%~p0library.bat" i2bm_get_osid
call "%~d0%~p0library.bat" i2bm_pathvar_find "%BRAINVISA_SOURCES%" "build-%SOMA_VERSION%-%result%-%SOMA_MODE%"
set BRAINVISA_BUILD=%result:~1,-1%
)

call "%~d0%~p0library.bat" i2bm_get_pythonexedir
set PYTHONEXE_DIR=%result:~1,-1%

set SIGRAPH_PATH=
set DCMDICTPATH=%BRAINVISA_BUILD%\lib\dicom.dic
set PYTHONPATH=%BRAINVISA_BUILD%\python;%PYTHONEXE_DIR%\Lib\site-packages;%PYTHONEXE_DIR%\Lib\site-packages\win32;%PYTHONEXE_DIR%\Lib\site-packages\win32\lib
set PYTHONHOME=%PYTHONEXE_DIR%
set ANATOMIST_PATH=
set SHFJ_SHARED_PATH=%BRAINVISA_BUILD%\share
set AIMS_PATH=
set PATH=%BRAINVISA_BUILD%\lib;%PYTHONEXE_DIR%\DLLs;%PYTHONEXE_DIR%;%BRAINVISA_BUILD%\bin;%PATH%
rem set PATH=%BUILDDIR%\lib;%PYTHONEXE_DIR%\DLLs;%PYTHONEXE_DIR%;%BUILDDIR%\bin;c:\Qt\3.3.8\lib;c:\msys\1.0\local\lib;c:\msys\1.0\local\bin;c:\msys\1.0\MinGW\bin;c:\msys\1.0\bin;C:\WINDOWS\system32;C:\WINDOWS;C:\WINDOWS\system32\Wbem;
