@echo off
rem --------------------------------------------------------
rem File: which.cmd
rem Description: Windows equivalent of Unix which command
rem Author:Paul Puglia
rem Based on code from http://stackoverflow.com/questions/304319/is-there-an-equivalent-of-which-on-windows
rem ---------------------------------------------------------
setlocal enableextensions enabledelayedexpansion

:: Needs an argument.

if "x%1"=="x" (
    echo Usage: which ^<progName^>
    goto :end
)

:: First try the unadorned filenmame.

set fullspec=
call :find_it %1

:: Then try all adorned filenames in order.

set mypathext=!pathext!
:loop1
    :: Stop if found or out of extensions.

    if "x!mypathext!"=="x" goto :loop1end

    :: Get the next extension and try it.

    for /f "delims=;" %%j in ("!mypathext!") do set myext=%%j
    call :find_it %1!myext!

:: Remove the extension (not overly efficient but it works).

:loop2
    if not "x!myext!"=="x" (
        set myext=!myext:~1!
        set mypathext=!mypathext:~1!
        goto :loop2
    )
    if not "x!mypathext!"=="x" set mypathext=!mypathext:~1!

    goto :loop1
:loop1end

:end
endlocal
goto :eof

:: Function to find and print a file in the path.

:find_it
    for %%i in (%1) do set fullspec=%%~$PATH:i
    if not "x!fullspec!"=="x" @echo.   !fullspec!
    goto :eof
