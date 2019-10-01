@echo OFF
REM creates .lib files required for compiling against DLLs with visual studio toolchain
REM @set THIS_DIR=%~d0%~p0

@set exit_code=0

REM @where lib
REM @if %errorlevel% neq 0 set exit_code=%errorlevel%
REM @if %errorlevel% neq 0 goto lib not found

@set DEF_FILE=%1
@set BUILD_ARCH=%2
@set OUT_FILE=%3

@set OUT_DIR=%OUT_FILE%\..\
@if not exist %OUT_DIR% mkdir %OUT_DIR%

lib /nologo /def:%DEF_FILE% /out:%OUT_FILE% /machine:%BUILD_ARCH%
@if %errorlevel% neq 0 set exit_code=%errorlevel%
@goto end

REM :error_no_vcvarsall
REM @echo ERROR: Cannot find file %VSDEVENV%.
REM @set exit_code=1
REM @goto end

:end
exit /b %exit_code%
