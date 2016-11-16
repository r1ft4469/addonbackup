@ECHO off
set SAVE_TO="%userprofile%\Google Drive\Projects\WoWAddons\"

cls
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

echo Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
echo args = "ELEV " >> "%vbsGetPrivileges%"
echo For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
echo args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
echo Next >> "%vbsGetPrivileges%"
echo UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
"%SystemRoot%\System32\WScript.exe" "%vbsGetPrivileges%" %*
exit /B

:gotPrivileges
setlocal & pushd .
cd /d %~dp0
if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul  &  shift /1)

echo Ready to Backup Addons and Settings for World of Warcraft
echo Backing up to %SAVE_TO%
pause
if exist %temp%\wow_install\ rmdir /S /Q %temp%\wow_install\
mkdir %temp%\wow_install\
xcopy /Q /E ".\addonbackup" %temp%\wow_install\
mklink /D %temp%\wow_install\Bin\WTF "%PROGRAMFILES(X86)%\World of Warcraft\WTF"
mklink /D %temp%\wow_install\Bin\Interface "%PROGRAMFILES(X86)%\World of Warcraft\Interface"
cd %temp%\wow_install\
upx --ultra-brute 7zsd.sfx 
cd Bin
..\7za a -mx=9 "..\Program.7z" * 
cd ..
copy /b 7zsd.sfx + Config.txt + Program.7z WoW_Settings.exe
del Program.7z
move %temp%\wow_install\WoW_Settings.exe %SAVE_TO%
cd ..
rmdir /S /Q wow_install\
cd %SAVE_TO%
git add WoW_Settings.exe
git commit -a -m Update
git push
echo Done Backing WoW Settings to %SAVE_TO%
pause