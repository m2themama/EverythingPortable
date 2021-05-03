@echo off
setlocal enabledelayedexpansion
setlocal enableextensions
Color 0A
cls
title Portable Firefox Launcher - Helper Edition
set nag=BE SURE TO TURN CAPS LOCK OFF! (never said it was on just make sure)
set new_version=OFFLINE_OR_NO_UPDATES
if exist replacer.bat del replacer.bat
if exist "%~n0_poc.bat" del "%~n0_poc.bat"
set "folder=%CD%"
if "%CD%"=="%~d0\" set "folder=%CD:~0,2%"

call :Alpha-To-Number
call :SetArch
call :FolderCheck
call :Version
call :Credits
call :HelperCheck

:Menu
cls
title Portable Firefox Launcher - Helper Edition - Main Menu
echo %NAG%
set nag="Selection Time!"
echo 1. reinstall firefox [will remove firefox entirely]
echo 2. launch firefox [launches firefox]
echo 3. reset firefox [will remove everything firefox except the binary]
echo 4. uninstall firefox [none of your friends on firefox?]
echo 5. update script [check for updates]
echo 6. credits [credits]
echo 7. exit [EXIT]
echo.
echo a. download dll's [dll errors anyone?]
echo.
echo b. download other projects [check out my other stuff]
echo.
echo c. write a quicklauncher [MAKE IT EVEN FASTER]
echo.
echo d. check for new firefox version [automatically check for a new version]
echo.
echo e. install text-reader [update if had]
echo.
set /p choice="enter a number and press enter to confirm: "
:: sets errorlevel to 0 (?)
ver > nul
:: an incorrect call throws an errorlevel of 1
:: replace all goto Main with (goto) 2>nul (if they are called by the main menu)
call :%choice%
REM if "%ERRORLEVEL%" NEQ "2" set nag="PLEASE Select A CHOICE 1-7 or a/b/c/d/e"
goto Menu

:Null
cls
set nag="NOT A FEATURE YET!"
(goto) 2>nul

:1
:ReinstallFirefox
cls
call :UninstallFirefox
call :UpgradeFirefox
(goto) 2>nul

:2
:LaunchFirefox
if not exist ".\bin\firefox\firefox.exe" set "nag=PLEASE INSTALL FIREFOX FIRST" && (goto) 2>nul
title DO NOT CLOSE
cls
echo FIREFOX IS RUNNING
start .\bin\firefox\firefox.exe -Profile "data/firefox/" "https://github.com/MarioMasta64/EverythingPortable/releases/latest/"
exit

:3
:ResetFirefox
taskkill /f /im firefox.exe
rmdir /s /q .\data\firefox\
(goto) 2>nul

:4
:UninstallFirefox
taskkill /f /im firefox.exe
rmdir /s /q .\bin\firefox\
(goto) 2>nul

:5
:UpdateCheck
if exist version.txt del version.txt
cls
title Portable Firefox Launcher - Helper Edition - Checking For Update
call :HelperDownload "https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/version.txt" "version.txt"
set Counter=0 & for /f "DELIMS=" %%i in ('type version.txt') do (set /a Counter+=1 & set "Line_!Counter!=%%i")
if exist version.txt del version.txt
set new_version=%Line_62%
if "%new_version%"=="OFFLINE" call :ErrorOffline & (goto) 2>nul
if %current_version% EQU %new_version% call :LatestBuild & (goto) 2>nul
if %current_version% LSS %new_version% call :NewUpdate & (goto) 2>nul
if %current_version% GTR %new_version% call :PreviewBuild & (goto) 2>nul
call :ErrorOffline & (goto) 2>nul
(goto) 2>nul

:6
:About
cls
del .\doc\firefox_license.txt
start launch_firefox.bat
exit

:7
exit

:a
:DLLDownloaderCheck
cls & title Portable Firefox Launcher - Helper Edition - Download Dll Downloader
call :HelperDownload "https://raw.githubusercontent.com/MarioMasta64/DLLDownloaderPortable/master/launch_dlldownloader.bat" "launch_dlldownloader.bat.1"
cls & if exist launch_dlldownloader.bat.1 del launch_dlldownloader.bat & rename launch_dlldownloader.bat.1 launch_dlldownloader.bat
cls & start launch_dlldownloader.bat
(goto) 2>nul

:b
:PortableEverything
cls & title Portable Firefox Launcher - Helper Edition - Download Suite
call :HelperDownload "https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_everything.bat" "launch_everything.bat.1"
cls & if exist launch_everything.bat.1 del launch_everything.bat & rename launch_everything.bat.1 launch_everything.bat
cls & start launch_everything.bat
(goto) 2>nul

:c
:QuicklauncherCheck
cls
title Portable Firefox Launcher - Helper Edition - Quicklauncher Writer
echo @echo off > quicklaunch_firefox.bat
echo Color 0A >> quicklaunch_firefox.bat
echo cls >> quicklaunch_firefox.bat
echo set "folder=%%CD%%" >> quicklaunch_firefox.bat
echo if "%%CD%%"=="%%~d0\" set "folder=%%CD:~0,2%%" >> quicklaunch_firefox.bat
echo set "UserProfile=%%folder%%\data\" >> quicklaunch_firefox.bat
echo set "AppData=%%folder%%\data\AppData\Roaming\" >> quicklaunch_firefox.bat
echo set "LocalAppData=%%folder%%\data\AppData\Local\" >> quicklaunch_firefox.bat
echo cls >> quicklaunch_firefox.bat
echo start .\bin\firefox\firefox.exe -Profile "data/firefox/" "https://github.com/MarioMasta64/EverythingPortable/releases/latest/" >> quicklaunch_firefox.bat
echo exit >> quicklaunch_firefox.bat
echo A QUICKLAUNCHER HAS BEEN WRITTEN TO: quicklaunch_firefox.bat
echo ENTER TO CONTINUE & pause>nul:
(goto) 2>nul

:d
:UpgradeFirefox
if exist index.html del index.html
call :HelperDownload "http://ftp.mozilla.org/pub/firefox/nightly/latest-mozilla-central/" "index.html"
for /f tokens^=2delims^=^" %%A in (
  'findstr /i /c:".en-US.win32.zip" index.html'
) Do > .\doc\firefox_link.txt Echo:%%A
if exist index.html del index.html
set /p firefox_link=<.\doc\firefox_link.txt
set "firefox_link=http://ftp.mozilla.org!firefox_link!"
set "firefox_zip=!firefox_link:~66!"
echo "!firefox_link!"
echo "!firefox_zip!"
if exist .\extra\!firefox_zip! (
  echo firefox is updated.
  pause
  exit /b
)
pause
if exist "!firefox_zip!" del "!firefox_zip!"
call :HelperDownload "!firefox_link!" "!firefox_zip!"
:MoveFirefox
move "!firefox_zip!" ".\extra\!firefox_zip!"
:ExtractFirefox
call :HelperExtract "!folder!\extra\!firefox_zip!" "!folder!\bin\"
(goto) 2>nul

:e
title Portable Firefox Launcher - Helper Edition - Text-Reader Update Check
cls
call :HelperDownload "https://mariomasta64.me/batch/text-reader/update-text-reader.bat" "update-text-reader.bat"
start "" "update-text-reader.bat"
(goto) 2>nul

REM PROGRAM SPECIFIC STUFF THAT CAN BE EASILY CHANGED BELOW
REM STUFF THAT IS ALMOST IDENTICAL BETWEEN STUFF

:FolderCheck
cls
set "UserProfile=!folder!\data\"
set "AppData=!folder!\data\AppData\Roaming\"
set "LocalAppData=!folder!\data\AppData\Local\"
if not exist .\bin\ mkdir .\bin\
if not exist .\data\ mkdir .\data\
if not exist .\doc\ mkdir .\doc\
if not exist .\extra\ mkdir .\extra\
if not exist .\helpers\ mkdir .\helpers\
if not exist .\note\ mkdir .\note\
if not exist .\data\AppData\Local\ mkdir .\data\AppData\Local\
if not exist .\data\AppData\Roaming\ mkdir .\data\AppData\Roaming\
if not exist ".\bin\firefox\firefox.exe" set nag=FIREFOX IS NOT INSTALLED CHOOSE "D"
(goto) 2>nul

:Version
cls
echo 1 > .\doc\version.txt
set /p current_version=<.\doc\version.txt
if exist .\doc\version.txt del .\doc\version.txt
:: REPLACE ALL exit /b that dont need an error code (a value after it) with "exit"
(goto) 2>nul

:Credits
cls
if exist .\doc\firefox_license.txt (goto) 2>nul
echo ================================================== > .\doc\firefox_license.txt
echo =              Script by MarioMasta64            = >> .\doc\firefox_license.txt
echo =           Script Version: v%current_version%- release        = >> .\doc\firefox_license.txt
echo ================================================== >> .\doc\firefox_license.txt
echo =You may Modify this WITH consent of the original= >> .\doc\firefox_license.txt
echo = creator, as long as you include a copy of this = >> .\doc\firefox_license.txt
echo =      as you include a copy of the License      = >> .\doc\firefox_license.txt
echo ================================================== >> .\doc\firefox_license.txt
echo =    You may also modify this script without     = >> .\doc\firefox_license.txt
echo =         consent for PERSONAL USE ONLY          = >> .\doc\firefox_license.txt
echo ================================================== >> .\doc\firefox_license.txt
cls
title Portable Firefox Launcher - Helper Edition - About
for /f "DELIMS=" %%i in (.\doc\firefox_license.txt) do (echo %%i)
pause
call :PingInstall
(goto) 2>nul

REM if a script can be used between files then it can be put here and re-written only if it doesnt exist
REM stuff here will not be changed between programs

:SetArch
set arch=32
if exist "%PROGRAMFILES(X86)%" set "arch=64"
(goto) 2>nul

:HelperCheck
if not exist launch_helpers.bat call :DownloadHelpers
(goto) 2>nul
:DownloadHelpers
if not exist .\helpers\download.vbs call :CreateDownloadVBS
cscript .\helpers\download.vbs https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_helpers.bat launch_helpers.bat > nul
(goto) 2>nul
:CreateDownloadVBS
echo Dim Arg, download, file > .\helpers\download.vbs
echo Set Arg = WScript.Arguments >> .\helpers\download.vbs
echo. >> .\helpers\download.vbs
echo download = Arg(0) >> .\helpers\download.vbs
echo file = Arg(1) >> .\helpers\download.vbs
echo. >> .\helpers\download.vbs
echo dim xHttp: Set xHttp = CreateObject("MSXML2.ServerXMLHTTP")>> .\helpers\download.vbs
echo dim bStrm: Set bStrm = createobject("Adodb.Stream") >> .\helpers\download.vbs
echo xHttp.Open "GET", download, False >> .\helpers\download.vbs
echo xHttp.Send >> .\helpers\download.vbs
echo. >> .\helpers\download.vbs
echo with bStrm >> .\helpers\download.vbs
echo     .type = 1 '//binary >> .\helpers\download.vbs
echo     .open >> .\helpers\download.vbs
echo     .write xHttp.responseBody >> .\helpers\download.vbs
echo     .savetofile file, 2 '//overwrite >> .\helpers\download.vbs
echo end with >> .\helpers\download.vbs
(goto) 2>nul

:HelperDownload
REM v1+ Required
echo 1 > .\helpers\version.txt
echo %1 > .\helpers\download.txt
echo %2 > .\helpers\file.txt
call launch_helpers.bat Download
(goto) 2>nul

:HelperDownloadWget
REM v3+ Required
echo 3 > .\helpers\version.txt
call launch_helpers.bat DownloadWget
(goto) 2>nul

:HelperExtract
REM v1+ Required
echo 1 > .\helpers\version.txt
echo %1 > .\helpers\file.txt
echo %2 > .\helpers\folder.txt
call launch_helpers.bat Extract
(goto) 2>nul

:HelperExtract7Zip
REM v3+ Required
echo 3 > .\helpers\version.txt
echo %1 > .\helpers\file.txt
echo %2 > .\helpers\folder.txt
call launch_helpers.bat Extract7Zip
(goto) 2>nul

:HelperHide
REM v4+ Required
echo 4 > .\helpers\version.txt
echo %1 > .\helpers\file.txt
call launch_helpers.bat Hide
(goto) 2>nul

:HelperReplaceText
REM v5+ Required
echo 5 > .\helpers\version.txt
echo %1 > .\helpers\file.txt
echo %2 > .\helpers\oldtext.txt
echo %3 > .\helpers\newtext.txt
call launch_helpers.bat ReplaceText
(goto) 2>nul

:HelperExtractInno
REM v8+ Required
echo 8 > .\helpers\version.txt
echo %1 > .\helpers\file.txt
echo %2 > .\helpers\folder.txt
call launch_helpers.bat ExtractInno
(goto) 2>nul

:PingInstall
for /F "skip=1 tokens=5" %%a in ('vol %~D0') do echo %%a>serial.txt
set /a count=1 
for /f "skip=1 delims=:" %%a in ('CertUtil -hashfile "serial.txt" sha1') do (
  if !count! equ 1 set "sha1=%%a"
  set/a count+=1
)
set "sha1=%sha1: =%
echo %sha1%
set program=%~n0
echo %program:~7%
echo "https://mariomasta64.me/install/new_install.php?program=%program:~7%^&serial=%sha1%"
REM call :HelperDownload "https://mariomasta64.me/install/new_install.php?program=%program:~7%^&serial=%sha1%" "new_install.php"
del new_install.php*
del serial.txt
(goto) 2>nul

:UpdateWget
cls
call launch_helpers.bat DownloadWget
(goto) 2>nul

:LatestBuild
cls
title Portable Firefox Launcher - Helper Edition - Latest Build :D
echo you are using the latest version!!
echo Current Version: v%current_version%
echo New Version: v%new_version%
echo ENTER TO CONTINUE & pause>nul:
start launch_firefox.bat
exit

:NewUpdate
cls
title Portable Firefox Launcher - Helper Edition - Old Build D:
echo %NAG%
set nag="Selection Time!"
echo you are using an older version
echo enter yes or no
echo Current Version: v%current_version%
echo New Version: v%new_version%
set /p choice="Update?: "
if "%choice%"=="yes" call :Update-Now & (goto) 2>nul
if "%choice%"=="no" (goto) 2>nul
set nag="please enter YES or NO"
goto NewUpdate

:UpdateNow
cls & title Portable Firefox Launcher - Helper Edition - Updating Launcher
call :HelperDownload "https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_firefox.bat" "launch_firefox.bat.1"
cls & if exist launch_firefox.bat.1 goto ReplacerCreate
cls & call :ErrorOffline
(goto) 2>nul

:ReplacerCreate
cls
echo @echo off > replacer.bat
echo Color 0A >> replacer.bat
echo del launch_firefox.bat >> replacer.bat
echo rename launch_firefox.bat.1 launch_firefox.bat >> replacer.bat
echo start launch_firefox.bat >> replacer.bat
:: launcher exits, deletes itself, and then exits again. yes. its magic.
echo (goto) 2^>nul ^& del "%%~f0" ^& exit >> replacer.bat
call :HelperHide "replacer.bat"
exit

:PreviewBuild
cls
title Portable Firefox Launcher - Helper Edition - Test Build :0
echo YOURE USING A TEST BUILD MEANING YOURE EITHER
echo CLOSE TO ME OR YOURE SOME SORT OF PIRATE
echo Current Version: v%current_version%
echo New Version: v%new_version%
echo ENTER TO CONTINUE & pause>nul:
start launch_firefox.bat
exit

:ErrorOffline
cls
set nag="YOU SEEM TO BE OFFLINE PLEASE RECONNECT TO THE INTERNET TO USE THIS FEATURE"
(goto) 2>nul

REM GENERAL PURPOSE SCRIPTS BELOW

:AlphaToNumber
set a=1
set b=2
set c=3
set d=4
set e=5
set f=6
set g=7
set h=8
set i=9
set j=10
set k=11
set l=12
set m=13
set n=14
set o=15
set p=16
set q=17
set r=18
set s=19
set t=20
set u=21
set v=22
set w=23
set x=24
set y=25
set z=26
(goto) 2>nul

:ViewCode
start notepad.exe "%~f0"
(goto) 2>nul

:MakeCopy
:SaveCopy
del "%~f0.bak"
copy "%~f0" "%~f0.bak"
(goto) 2>nul

:Cmd
cls
title Portable Firefox Launcher - Helper Edition - Command Prompt - By MarioMasta64
ver
echo (C) Copyright Microsoft Corporation. All rights reserved
echo.
echo nice job finding me. have fun with my little cmd prompt.
echo upon error (more likely than not) i will return to the menu.
echo type "(goto) 2^>nul" or make me error to return.
echo.
:CmdLoop
set /p "cmd=%cd%>"
if "%cmd%"=="reset-cmd" call :Cmd
%cmd%
echo.
goto CmdLoop

:Relaunch
echo @echo off > relaunch.bat
echo cls >> relaunch.bat
echo Color 0A >> relaunch.bat
echo start %~f0 >> relaunch.bat
:: launcher exits, deletes itself, and then exits again. yes. its magic.
echo (goto) 2^>nul ^& del "%%~f0" ^& exit >> relaunch.bat
call :HelperHide "relaunch.bat"
exit