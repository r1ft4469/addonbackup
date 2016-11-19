@echo off
IF EXIST "%PROGRAMFILES(X86)%\World of Warcraft\Wow.exe" (
	SET WOWDIR="%PROGRAMFILES(X86)%\World of Warcraft\" 
	SET INTERFACEDIR="%PROGRAMFILES(X86)%\World of Warcraft\Interface\"
	SET WTFDIR="%PROGRAMFILES(X86)%\World of Warcraft\WTF\"
	GOTO :OPT
	) ELSE (
	IF EXIST "%PROGRAMFILES%\World of Warcraft\Wow.exe" (
		SET WOWDIR="%PROGRAMFILES%\World of Warcraft\" 
		SET INTERFACEDIR="%PROGRAMFILES%\World of Warcraft\Interface\"
		SET WTFDIR="%PROGRAMFILES%\World of Warcraft\WTF\"
		GOTO :OPT
		)
	)
GOTO :EOF

:OPT
RMDIR /S /Q %INTERFACEDIR%
RMDIR /S /Q %WTFDIR%
XCOPY /E Interface %INTERFACEDIR%
XCOPY /E WTF %WTFDIR%