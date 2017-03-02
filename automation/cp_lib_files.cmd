@echo off

@set fp=%1
@set src_dir=%2
@set target_dir=%3
@set xcopy_options= /MT:1 /R:2 /NJS /NJH 
REM %4 %5 %6 %7 %8 %9

@set FilePattern=*%fp%*

set exit_code=0

@if not exist %target_dir% set exit_code=1
@if not exist %target_dir% goto exit

robocopy %src_dir% %target_dir% %FilePattern%.dll %xcopy_options%
robocopy %src_dir% %target_dir% %FilePattern%.lib %xcopy_options%
if exist %src_dir%%FilePattern%.pdb robocopy %src_dir% %target_dir% %FilePattern%.pdb %xcopy_options%
@if not errorlevel 0 set exit_code=%errorlevel%
@if not errorlevel 0 goto exit
:: xcopy %src_dir%\jsoncpp.* %target_dir% %xcopy_options%


:exit
REM set src_dir=
REM set xcopy_options=
REM set target_dir=

exit /b %exit_code%
