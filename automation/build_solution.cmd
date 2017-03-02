@echo off

:: .\build_solution.cmd Debug x64 MSBuild.exe Build c:\src\path\to\solution.sln

@set BuildConfiguration=%1
@set BuildPlatform=%2
@set MSB=%3
@set Mode=%4
@set solution=%5

@if not "%BuildConfiguration%"=="Release" if not "%BuildConfiguration%"=="Debug" set BuildConfiguration=Release
@if not "%BuildPlatform%"=="x64" if not "%BuildPlatform%"=="Win32" set BuildPlatform=x64

:: Note: need to use the msbuild under program files, not the FW one. 
:: Odd, probably only my machine. Otherwise:
:: error MSB4019: The imported project "C:\Program Files (x86)\MSBuild\
::Microsoft.Cpp\v4.0\V110\Microsoft.Cpp.Default.props" was not found. Confirm tha
::t the path in the <Import> declaration is correct, and that the file exists on
::disk.
:: set MSB=%windir%\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe
@if not defined MSB set MSB="MSBuild.exe"

@if not defined Mode set Mode=Build
:: @if not "%Mode%"=="Build" if not "%Mode%"=="Rebuild" set Mode=Build
@set SLN=%solution%

@if not exist %SLN% set exit_code=1
@if not exist %SLN% goto SLN_Notfound

:: === code compilation settings
@set build_options=/t:%Mode% /p:Configuration=%BuildConfiguration% /p:Platform=%BuildPlatform% /m  /consoleloggerparameters:ErrorsOnly
@echo "*** Build parameters: BuildConfiguration=%BuildConfiguration% platform=%BuildPlatform% Mode=%Mode% ***"
%MSB% %SLN% %build_options%
@if not errorlevel 0 set exit_code=%errorlevel%
@if not errorlevel 0 goto Build_fail

@echo "*** COMPLETED: Build parameters: BuildConfiguration=%BuildConfiguration% platform=%BuildPlatform% Mode=%Mode% ***"

goto exit

:SLN_Notfound
@echo ERROR: Solution file not found (%SLN%)
@goto exit

:Build_fail
@echo ERROR: Building (%SLN%) %BuildConfiguration% %BuildPlatform% - FAILED
@goto exit

:exit
exit /b %exit_code%
