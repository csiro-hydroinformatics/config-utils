@echo OFF
REM ===============================================
REM Note that this returns a cygwin style path with slashes, to workaround an oddity with ash+sed in configure.win
REM ===============================================

REM TODO if not defined LIBRARY_PATH

set INCL_PATH=%INCLUDE_PATH%
REM TODO split on ;

REM Remove a trailing '\' that causes grief in configure.win
REM @if not "%MSBuildToolsPath%"=="" set MSBuildToolsPath=%MSBuildToolsPath:~0,-1%
REM It proved easier to substitute in DOS than with ash+sed. Sigh.
set INCL_PATH_UNIX=%INCL_PATH:\=/%
@echo %INCL_PATH_UNIX%