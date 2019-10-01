@echo OFF

:: .\cp_binaries.cmd pattern project_dir c:\localdev\libs Debug clean
:: .\cp_binaries.cmd rpp C:\src\csiro\stash\per202\rpp-cpp c:\localdev\libs Debug clean

set exit_code=0

@set fp=%1
@set RootProjDir=%2
@set SharedLibDirTarget=%3
@set bc=%4
@set clean=%5

@set FilePattern=*%fp%*


@if not exist %RootProjDir% set exit_code=1
@if not exist %RootProjDir% echo ERROR: RootProjDir = %RootProjDir% does not exist
@if not exist %RootProjDir% goto exit

@if not exist %SharedLibDirTarget% set exit_code=1
@if not exist %SharedLibDirTarget% echo ERROR: SharedLibDirTarget = %SharedLibDirTarget% does not exist
@if not exist %SharedLibDirTarget% goto exit

@if not defined bc set bc=Release
@if not "%bc%"=="Release" if not "%bc%"=="Debug" set bc=Release

@if not "%clean%"=="clean" if not "%clean%"=="noclean" set clean=noclean

@echo *** Updating native libraries:  %RootProjDir% ==> %bc% (%SharedLibDirTarget%, %clean%)

@set out_dir_64=%SharedLibDirTarget%\64\
@set out_dir_32=%SharedLibDirTarget%\32\
@if not exist %out_dir_64% mkdir %out_dir_64% 
@if not exist %out_dir_32% mkdir %out_dir_32% 

@if "%clean%"=="clean" if exist %out_dir_64%\%FilePattern%.* del %out_dir_64%\%FilePattern%.* /Q
@if "%clean%"=="clean" if exist %out_dir_32%\%FilePattern%.* del %out_dir_32%\%FilePattern%.* /Q

call %~d0%~p0.\cp_lib_files.cmd %fp% %RootProjDir%\x64\%bc%\ %out_dir_64% 
@if %errorlevel% neq 0 set exit_code=%errorlevel%
@if %errorlevel% neq 0 goto exit
call %~d0%~p0.\cp_lib_files.cmd %fp% %RootProjDir%\Win32\%bc%\ %out_dir_32% 
@if %errorlevel% neq 0 set exit_code=%errorlevel%
@if %errorlevel% neq 0 goto exit

:exit
exit /b %exit_code%
