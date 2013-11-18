@echo off
@setlocal
@set directory="%~d0%~p0"
@"%directory:~1,-1%bv_env.exe" > %TMP%/bv_env.bat
@endlocal
%TMP%/bv_env.bat