@echo off

@set exit_code=0
@set error_msg=""

REM load Visual Studio 2017 developer command prompt setup has changed compared to previous versions. 
REM Inspired from: https://github.com/ctaggart  via https://github.com/Microsoft/visualfsharp/pull/2690/commits/bf52776167fe6a9f2354ea96094a025191dbd3e7

set VsDevCmdFile=\Common7\Tools\VsDevCmd.bat

set progf=%ProgramFiles(x86)%\Microsoft Visual Studio\2019\
if exist "%progf%" (
    goto foundVsDevCmdFile
) else (
    echo "WARNING: failed to locate VS2019 at %progf%"
    echo "WARNING: will try successive fallback options"
)

@REM # fallback 
set progf=%ProgramFiles(x86)%\Microsoft Visual Studio\2019\
if exist "%progf%" (
    goto foundVsDevCmdFile
) else (
    echo "WARNING: fallback to use VS2019 failed, no path found at %progf%"
    echo "WARNING: will try 'VS2017' fallback option"
    goto fallbackVSCOMNTOOLS
)

@REM # fallback 
set progf=%ProgramFiles(x86)%\Microsoft Visual Studio\2017\
if exist "%progf%" (
    goto foundVsDevCmdFile
) else (
    echo "WARNING: fallback to use VS2017 failed, no path found at %progf%"
    echo "WARNING: will try 'build tool' fallback options"
    goto fallbackVSCOMNTOOLS
)

:foundVsDevCmdFile

set "editions=Community Professional Enterprise BuildTools"

for %%e in (%editions%) do (
    if exist "%progf%%%e%VsDevCmdFile%" (
        echo INFO: found "%progf%%%e%VsDevCmdFile%"
        call "%progf%%%e%VsDevCmdFile%"
        goto end
    )
)

:fallbackVSCOMNTOOLS
REM for instance C:\bin\VS2012\Common7\Tools\
if defined VSCOMNTOOLS (
    goto found
)

if defined VS140COMNTOOLS set VSCOMNTOOLS=%VS140COMNTOOLS%
if defined VS140COMNTOOLS goto found
if defined VS120COMNTOOLS set VSCOMNTOOLS=%VS120COMNTOOLS%
if defined VS120COMNTOOLS goto found
if defined VS110COMNTOOLS set VSCOMNTOOLS=%VS110COMNTOOLS%
if defined VS110COMNTOOLS goto found

@echo ERROR: Could not locate command prompt devenv setup for anything between VS2012 and VS2017
@set exit_code=127
@goto end

:found
echo "INFO: found env var for common tools under %VSCOMNTOOLS%"
set VSDEVENV=%VSCOMNTOOLS%..\..\VC\vcvarsall.bat
@if not exist "%VSDEVENV%" goto error_no_vcvarsall
@call "%VSDEVENV%"
@goto end

:error_no_vcvarsall
@echo ERROR: Cannot find file %VSDEVENV%.
@set exit_code=1
@goto end

:end
if %exit_code% neq 0 (
    echo ERROR: %error_msg%
) else (
    echo INFO: setup_vcpp completed without error
)
exit /b %exit_code%

