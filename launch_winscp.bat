@echo off
setlocal enabledelayedexpansion
setlocal enableextensions
Color 0A
cls
title Portable WinSCP Launcher - Helper Edition
set nag=Finally Getting Updates After 4 Years (Helper Update)
set new_version=OFFLINE_OR_NO_UPDATES

set "name=%~n0"
set "name=!name:launch_=!"
set "license=.\doc\!name!_license.txt"
set "main_launcher=%~n0.bat"
set "poc_launcher=%~n0_poc.bat"
set "quick_launcher=quick%~n0.bat"

if exist replacer.bat del replacer.bat >nul
if exist !poc_launcher! del !poc_launcher! >nul
set "folder=%CD%"
if "%CD%"=="%~d0\" set "folder=%CD:~0,2%"

call :AlphaToNumber
call :SetArch
call :FolderCheck
call :Version
call :Credits
call :HelperCheck

:Menu
cls
title Portable WinSCP Launcher - Helper Edition - Main Menu
echo %NAG%
set nag="Selection Time!"
echo 1. reinstall winscp [will remove winscp entirely]
echo 2. launch winscp [launches winscp]
echo 3. reset winscp [will remove everything winscp except the binary]
echo 4. uninstall winscp [prefer filezilla or something?]
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
echo d. check for new winscp version [automatically check for a new version]
echo.
echo e. install text-reader [update if had]
echo.
echo f. update putty [update if had]
echo g. update winscppwd [update if had]
echo.
echo h. launch putty [launches putty]
echo i. launch winscppwd [launches winscppwd]
echo.
set /p choice="enter a number and press enter to confirm: "
:: sets errorlevel to 0 (?)
ver >nul
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
:ReinstallWinSCP
cls
call :UninstallWinSCP
call :UpgradeWinSCP
(goto) 2>nul

:2
:LaunchWinSCP
if not exist ".\bin\WinSCP\WinSCP.exe" set "nag=PLEASE INSTALL WINSCP FIRST" & (goto) 2>nul
title DO NOT CLOSE
cls
echo WINSCP IS RUNNING
cd .\bin\WinSCP\
start WinSCP.exe
REM add registry pull sometime
exit

:3
:ResetWinSCP
if exist .\AppData\Roaming\winscp.rnd del .\AppData\Roaming\winscp.rnd >nul
(goto) 2>nul

:4
:UninstallWinSCP
if exist .\bin\WinSCP\ rmdir /s /q .\bin\WinSCP\
(goto) 2>nul

:5
:UpdateCheck
if exist version.txt del version.txt >nul
cls
title Portable WinSCP Launcher - Helper Edition - Checking For Update
call :HelperDownload "https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/version.txt" "version.txt"
set Counter=0 & for /f "DELIMS=" %%i in ('type version.txt') do (set /a Counter+=1 & set "Line_!Counter!=%%i")
if exist version.txt del version.txt >nul
set new_version=%Line_58%
if "%new_version%"=="OFFLINE" call :ErrorOffline & (goto) 2>nul
if %current_version% EQU %new_version% call :LatestBuild & (goto) 2>nul
if %current_version% LSS %new_version% call :NewUpdate & (goto) 2>nul
if %current_version% GTR %new_version% call :PreviewBuild & (goto) 2>nul
call :ErrorOffline & (goto) 2>nul
(goto) 2>nul

:6
:About
cls
if exist !license! del !license! >nul
start "!main_launcher!"
exit

:7
exit

:a
:DLLDownloaderCheck
cls & title Portable WinSCP Launcher - Helper Edition - Download Dll Downloader
call :HelperDownload "https://raw.githubusercontent.com/MarioMasta64/DLLDownloaderPortable/master/launch_dlldownloader.bat" "launch_dlldownloader.bat.1"
cls & if exist launch_dlldownloader.bat.1 del launch_dlldownloader.bat >nul & rename launch_dlldownloader.bat.1 launch_dlldownloader.bat
cls & start launch_dlldownloader.bat
(goto) 2>nul

:b
:PortableEverything
cls & title Portable WinSCP Launcher - Helper Edition - Download Suite
call :HelperDownload "https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_everything.bat" "launch_everything.bat.1"
cls & if exist launch_everything.bat.1 del launch_everything.bat >nul & rename launch_everything.bat.1 launch_everything.bat
cls & start launch_everything.bat
(goto) 2>nul

:c
:QuicklauncherCheck
cls
title Portable WinSCP Launcher - Helper Edition - Quicklauncher Writer
echo @echo off >!quick_launcher!
echo Color 0A >>!quick_launcher!
echo cls >>!quick_launcher!
echo set "folder=%%CD%%" >>!quick_launcher!
echo if "%%CD%%"=="%%~d0\" set "folder=%%CD:~0,2%%" >>!quick_launcher!
echo set "UserProfile=%%folder%%\data" >>!quick_launcher!
echo set "AppData=%%folder%%\data\AppData\Roaming" >>!quick_launcher!
echo set "LocalAppData=%%folder%%\data\AppData\Local" >>!quick_launcher!
echo set "ProgramData=%%folder%%\data\ProgramData" >>!quick_launcher!
echo cls >>!quick_launcher!
echo cd .\bin\WinSCP\ >>!quick_launcher!
echo start WinSCP.exe >>!quick_launcher!
echo exit >>!quick_launcher!
echo A QUICKLAUNCHER HAS BEEN WRITTEN TO:!quick_launcher!
echo ENTER TO CONTINUE & pause >nul
exit

:d
:UpgradeWinSCP
if exist history del history >nul
if exist winscp_release.txt del winscp_release.txt >nul
if exist winscp_beta.txt del winscp_beta.txt >nul
call :HelperDownload "https://winscp.net/eng/docs/history" "history"
echo.> winscp_link.txt
for /f tokens^=2delims^=^> %%A in (
  'findstr /i /c:"h2 id=" history'
) Do >> winscp_link.txt Echo:%%A
if exist history del history >nul
set /a release=0
set /a beta=0
set /a rc=0
set /a hotfix=0
for /F "tokens=*" %%A in (winscp_link.txt) do (
  set "A=%%A"
  set "A=!A:~0,-4!"
  if "!A:~-18!" EQU "(not released yet)" (
    echo "!A:~0,-19! is not released"
  )
  if "!A:~-8!" EQU "(hotfix)" (
    echo "!A:~0,-9! is a hotfix"
  )
  if "!A:~-4!" EQU "beta" (
    echo "https://winscp.net/download/WinSCP-!A:~0,-5!.beta-Portable.zip"
    if !beta! EQU 0 (
      set /a beta+=1
      echo !A:~0,-5!>winscp_beta.txt
    )
  )
  if "!A:~-2!" EQU "RC" (
    echo "!A:~0,-3! is a release-candidate build"
  )
  if "!A:~-18!" NEQ "(not released yet)" (
    if "!A:~-8!" NEQ "(hotfix)" (
      if "!A:~-4!" NEQ "beta" (
        if "!A:~-2!" NEQ "RC" (
          echo "https://winscp.net/download/WinSCP-!A!-Portable.zip"
          if !release! EQU 0 (
            if exist winscp_beta.txt (
              set /a release+=1
              echo !A!>winscp_release.txt
            )
          )
        )
      )
    )
  )
)
if exist winscp_link.txt del winscp_link.txt >nul
echo.
set /p winscp_release=<winscp_release.txt
set /p winscp_beta=<winscp_beta.txt
if exist winscp_release.txt del winscp_release.txt >nul
if exist winscp_beta.txt del winscp_beta.txt >nul
cls
set "release_zip_link=https://winscp.net/download/WinSCP-!winscp_release!-Portable.zip"
set "beta_zip_link=https://winscp.net/download/WinSCP-!winscp_beta!.beta-Portable.zip"
set "release_txt_link=https://winscp.net/download/WinSCP-!winscp_release!-ReadMe.txt"
set "beta_txt_link=https://winscp.net/download/WinSCP-!winscp_beta!.beta-ReadMe.txt"
set "release_zip_file=WinSCP-!winscp_release!-Portable.zip"
set "beta_zip_file=WinSCP-!winscp_beta!.beta-Portable.zip"
set "release_txt_file=WinSCP-!winscp_release!-ReadMe.txt"
set "beta_txt_file=WinSCP-!winscp_beta!.beta-ReadMe.txt"
echo release zip link: !release_zip_link!
echo beta zip link: !beta_zip_link!
:: echo rc zip link: [wip]
:: echo hotfix zip link: [wip]
echo release zip file: !release_zip_file!
echo beta zip file: !beta_zip_file!
:: echo rc zip file: [wip]
:: echo hotfix zip file: [wip]
echo release txt link: !release_txt_link!
echo beta txt link: !beta_txt_link!
:: echo rc txt link: [wip]
:: echo hotfix txt link: [wip]
echo release txt file: !release_txt_file!
echo beta txt file: !beta_txt_file!
:: echo rc txt file: [wip]
:: echo hotfix txt file: [wip]
pause
cls
:ReadWinSCP
call :HelperDownload "!release_txt_link!" "!release_txt_file!"
move "!release_txt_file!" ".\doc\!release_txt_file!"
if exist batch-read.bat call batch-read.bat ".\doc\!release_txt_file!" 10 1
:DownloadWinSCP
call :HelperDownload "!release_zip_link!" "!release_zip_file!"
:MoveWinSCP
move "!release_zip_file!" ".\extra\!release_zip_file!"
:ExtractWinSCP
call :HelperExtract "!folder!\extra\!release_zip_file!" "!folder!\bin\WinSCP\"
(goto) 2>nul

:e
title Portable WinSCP Launcher - Helper Edition - Text-Reader Update Check
cls
call :HelperDownload "https://mariomasta64.me/batch/text-reader/update-text-reader.bat" "update-text-reader.bat"
start "" "update-text-reader.bat"
(goto) 2>nul

:f
:DownloadPutty
call :HelperDownload "https://winscp.net/download/putty.exe" "putty.exe"
move putty.exe .\bin\WinSCP\putty.exe
call :HelperDownload "https://winscp.net/download/puttygen.exe" "puttygen.exe"
move puttygen.exe .\bin\WinSCP\puttygen.exe
call :HelperDownload "https://winscp.net/download/pageant.exe" "pageant.exe"
move pageant.exe .\bin\WinSCP\pageant.exe
(goto) 2>nul

:g
:DownloadWinSCPPWD
call :Null & (goto) 2>nul
call :HelperDownload "https://bitbucket.org/knarf/winscppwd/downloads/winscppwd.exe" "winscppwd.exe"
move winscppwd.exe .\bin\WinSCP\winscppwd.exe
(goto) 2>nul

:h
:LaunchPutty
cls
echo PUTTY IS RUNNING
cd .\bin\WinSCP\
start Putty.exe
exit

:i
:LaunchWinSCPPWD
call :Null & (goto) 2>nul
cls
cd .\bin\WinSCP\
winscppwd winscp.ini > "!folder!\password.txt"
cd ..\..\
if exist batch-read.bat call batch-read.bat "!folder!\password.txt" 10 1 & goto :SkipNotePad
notepad.exe "!folder!\password.txt"
:SkipNotePad
if exist password.txt del password.txt >nul
(goto) 2>nul

REM PROGRAM SPECIFIC STUFF THAT CAN BE EASILY CHANGED BELOW
REM STUFF THAT IS ALMOST IDENTICAL BETWEEN STUFF

:FolderCheck
cls
set "UserProfile=!folder!\data"
set "AppData=!folder!\data\AppData\Roaming"
set "LocalAppData=!folder!\data\AppData\Local"
set "ProgramData=!folder!\data\ProgramData"
if not exist .\bin\ mkdir .\bin\
if not exist .\data\ mkdir .\data\
if not exist .\doc\ mkdir .\doc\
if not exist .\extra\ mkdir .\extra\
if not exist .\helpers\ mkdir .\helpers\
if not exist .\ini\ mkdir .\ini\
if not exist .\note\ mkdir .\note\
if not exist .\data\AppData\Local\ mkdir .\data\AppData\Local\
if not exist .\data\AppData\Roaming\ mkdir .\data\AppData\Roaming\
if not exist .\data\ProgramData\ mkdir .\data\ProgramData\
if not exist ".\data\3D Objects\" mkdir ".\data\3D Objects\"
if not exist ".\data\Contacts\" mkdir ".\data\Contacts\"
if not exist ".\data\Desktop\" mkdir ".\data\Desktop\"
if not exist ".\data\Documents\" mkdir ".\data\Documents\"
if not exist ".\data\Downloads\" mkdir ".\data\Downloads\"
if not exist ".\data\Favorites\" mkdir ".\data\Favorites\"
if not exist ".\data\Links\" mkdir ".\data\Links\"
if not exist ".\data\Music\" mkdir ".\data\Music\"
if not exist ".\data\OneDrive\" mkdir ".\data\OneDrive\"
if not exist ".\data\Pictures\" mkdir ".\data\Pictures\"
if not exist ".\data\Saved Games\" mkdir ".\data\Saved Games\"
if not exist ".\data\Searches\" mkdir ".\data\Searches\"
if not exist ".\data\Videos\" mkdir ".\data\Videos\"
if not exist ".\bin\WinSCP\WinSCP.exe" set nag=WINSCP IS NOT INSTALLED CHOOSE "D"
(goto) 2>nul

:Version
cls
echo 3 > .\doc\version.txt
set /p current_version=<.\doc\version.txt
if exist .\doc\version.txt del .\doc\version.txt >nul
(goto) 2>nul

:Credits
cls
if exist !license! (goto) 2>nul
echo ================================================== > !license!
echo =              Script by MarioMasta64            = >> !license!
set "extra_space="
if %current_version% LSS 10 set "extra_space= "
echo =           Script Version: v%current_version%- release        %extra_space%= >> !license!
echo ================================================== >> !license!
echo =You may Modify this WITH consent of the original= >> !license!
echo = creator, as long as you include a copy of this = >> !license!
echo =      as you include a copy of the License      = >> !license!
echo ================================================== >> !license!
echo =    You may also modify this script without     = >> !license!
echo =         consent for PERSONAL USE ONLY          = >> !license!
echo ================================================== >> !license!
cls
title Portable WinSCP Launcher - Helper Edition - About
for /f "DELIMS=" %%i in (!license!) do (echo %%i)
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
cscript .\helpers\download.vbs https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_helpers.bat launch_helpers.bat >nul
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

:HelperDownloadJava
REM v10+ Required But Always Updated Anyways
echo 9999 > .\helpers\version.txt
call launch_helpers.bat DownloadJava
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
if exist new_install.php del new_install.php >nul
if exist serial.txt del serial.txt >nul
REM call :HelperDownload "https://mariomasta64.me/install/new_install.php?program=%program:~7%^&serial=%sha1%" "new_install.php"
if exist new_install.php del new_install.php >nul
if exist serial.txt del serial.txt >nul
(goto) 2>nul

:UpdateWget
cls
call launch_helpers.bat DownloadWget
(goto) 2>nul

:LatestBuild
cls
title Portable WinSCP Launcher - Helper Edition - Latest Build :D
echo you are using the latest version!!
echo Current Version: v%current_version%
echo New Version: v%new_version%
echo ENTER TO CONTINUE & pause >nul
start "!main_launcher!"
exit

:NewUpdate
cls
title Portable WinSCP Launcher - Helper Edition - Old Build D:
echo %NAG%
set nag="Selection Time!"
echo you are using an older version
echo enter yes or no
echo Current Version: v%current_version%
echo New Version: v%new_version%
set /p choice="Update?: "
if "%choice%"=="yes" call :UpdateNow & (goto) 2>nul
if "%choice%"=="no" (goto) 2>nul
set nag="please enter YES or NO"
goto NewUpdate

:UpdateNow
cls & title Portable WinSCP Launcher - Helper Edition - Updating Launcher
call :HelperDownload "https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/!main_launcher!" "!main_launcher!.1"
cls & if exist "!main_launcher!.1" goto ReplacerCreate
cls & call :ErrorOffline
(goto) 2>nul

:ReplacerCreate
cls
echo @echo off > replacer.bat
echo Color 0A >> replacer.bat
echo del "!main_launcher!" >> replacer.bat
echo rename "!main_launcher!.1" "!main_launcher!" >> replacer.bat
echo start "" "!main_launcher!" >> replacer.bat
:: launcher exits, deletes itself, and then exits again. yes. its magic.
echo (goto) 2^ >nul ^& del "%%~f0" ^& exit >> replacer.bat
call :HelperHide "replacer.bat"
exit

:PreviewBuild
cls
title Portable WinSCP Launcher - Helper Edition - Test Build :0
echo YOURE USING A TEST BUILD MEANING YOURE EITHER
echo CLOSE TO ME OR YOURE SOME SORT OF PIRATE
echo Current Version: v%current_version%
echo New Version: v%new_version%
echo ENTER TO CONTINUE & pause >nul
start "!main_launcher!"
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
title Portable WinSCP Launcher - Helper Edition - Command Prompt - By MarioMasta64
ver
echo (C) Copyright Microsoft Corporation. All rights reserved
echo.
echo nice job finding me. have fun with my little cmd prompt.
echo upon error (more likely than not) i will return to the menu.
echo type "(goto) 2^ >nul" or make me error to return.
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
echo (goto) 2^ >nul ^& del "%%~f0" ^& exit >> relaunch.bat
call :HelperHide "relaunch.bat"
exit