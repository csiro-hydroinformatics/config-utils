@echo OFF

:: .\cp_binaries.cmd pattern project_dir c:\localdev\libs Debug clean
:: .\cp_binaries.cmd rpp C:\src\path\to\src c:\localdev\libs Debug clean

set exit_code=0

@set fp=%1
@set RootProjDir=%2
@set SharedLibDirTarget=%3
@set bc=%4
@set clean=%5

@set FilePattern=*%fp%*


@if not defined bc set bc=Release
@if not "%bc%"=="Release" if not "%bc%"=="Debug" set bc=Release

@if not exist %SharedLibDirTarget% set exit_code=1
@if not exist %SharedLibDirTarget% echo ERROR: SharedLibDirTarget = %SharedLibDirTarget% does not exist
@if not exist %SharedLibDirTarget% goto exit

@if not "%clean%"=="clean" if not "%clean%"=="noclean" set clean=noclean

call cp_binaries.cmd %fp% %RootProjDir% %SharedLibDirTarget% %bc% %clean%


:exit
exit /b %exit_code%
