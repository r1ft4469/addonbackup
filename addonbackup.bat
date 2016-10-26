@ECHO off
CLS
:init
setlocal DisableDelayedExpansion
set "batchPath=%~0"
for %%k in (%0) do set batchName=%%~nk
set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
setlocal EnableDelayedExpansion

:checkPrivileges
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)

ECHO Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
ECHO args = "ELEV " >> "%vbsGetPrivileges%"
ECHO For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
ECHO args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
ECHO Next >> "%vbsGetPrivileges%"
ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
"%SystemRoot%\System32\WScript.exe" "%vbsGetPrivileges%" %*
exit /B

:gotPrivileges
setlocal & pushd .
cd /d %~dp0
if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul  &  shift /1)

SET SAVE_TO="%userprofile%\Google Drive\"
ECHO Ready to Backup Addons and Settings for World of Warcraft
ECHO Backing up to %SAVE_TO%
PAUSE
IF EXIST %temp%\wow_install\ rmdir /S /Q %temp%\wow_install\
mkdir %temp%\wow_install\
XCOPY /Q /E ".\addonbackup" %temp%\wow_install\
MKLINK /D %temp%\wow_install\Bin\WTF "%PROGRAMFILES(X86)%\World of Warcraft\WTF"
MKLINK /D %temp%\wow_install\Bin\Interface "%PROGRAMFILES(X86)%\World of Warcraft\Interface"
CD %temp%\wow_install\
upx --ultra-brute 7zsd.sfx 
cd Bin
..\7za a -mx=9 "..\Program.7z" * 
cd ..
copy /b 7zsd.sfx + Config.txt + Program.7z WoW_Settings.exe
del Program.7z
MOVE %temp%\wow_install\WoW_Settings.exe %SAVE_TO%
CD ..
RMDIR /S /Q wow_install\
ECHO Done Backing WoW Settings to %SAVE_TO%
PAUSE