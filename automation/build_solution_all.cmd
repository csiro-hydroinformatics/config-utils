@echo off

REM f:

@set bc=%1
@set MSB=%2
@set Mode=%3
@set solution=%4

@if not defined bc set bc=Release
@if not "%bc%"=="Release" if not "%bc%"=="Debug" set bc=Release
@if not defined MSB set MSB=MSBuild.exe
@if not defined Mode set Mode=Build

REM set current_dir=%~d0%~p0.\
REM call %current_dir%common_setup.cmd
REM @if %errorlevel% neq 0 set exit_code=%errorlevel%
REM @if %errorlevel% neq 0 goto exit


@echo "*** Build configuration: %bc% ***"

:: Build the 64 bits native binaries
set BuildPlatform=x64
call %~d0%~p0.\build_solution.cmd %bc% %BuildPlatform% %MSB% %Mode% %solution%
@if %errorlevel% neq 0 set exit_code=%errorlevel%
@if %errorlevel% neq 0 goto exit
@echo "*** %bc%, %BuildPlatform% COMPLETE ***"

:: Build the 32 bits native binaries
set BuildPlatform=Win32
call %~d0%~p0.\build_solution.cmd %bc% %BuildPlatform% %MSB% %Mode% %solution%
@if %errorlevel% neq 0 set exit_code=%errorlevel%
@if %errorlevel% neq 0 goto exit
@echo "*** %bc%, %BuildPlatform% COMPLETE ***"

set exit_code=0

:exit
:: For convenience, change directory back to the location of this build script
cd %~dp0
exit /b %exit_code%
