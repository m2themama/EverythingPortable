@echo off
cls
Color 0A

setlocal enabledelayedexpansion
set "folder=%~dp0"
set "folder=!folder:~0,-1!"
pushd "!folder!"

if not exist .\extra\ mkdir .\extra\

:main
cls
echo i really dont like the way this is setup but here
echo.
echo st: Start Roblox
echo sd: Shutdown Roblox
echo.
echo dl: Download Roblox
echo.
set /p choice="choice: "
call :%choice%
goto main

:sd
cls
taskkill /f /im RobloxPlayerBeta.exe
taskkill /f /im RobloxPlayerInstaller.exe
taskkill /f /im RobloxStudioInstaller.exe
goto main

:st
cls
if exist ".\data\roblox\" (
	rmdir /s /q "!LocalAppData!\Roblox\"
	xcopy /e /i /y ".\data\roblox\*" "!LocalAppData!\Roblox\"
	if exist "!LocalAppData!\Roblox\" rmdir /s /q ".\data\roblox\" else echo Cannot Write To LocalAppData && pause && goto main
)
pushd !LocalAppData!\Roblox\Versions\version*
RobloxPlayerBeta.exe
popd
if exist "!LocalAppData!\Roblox\" (
	rmdir /s /q ".\data\roblox\"
	xcopy /e /i /y "!LocalAppData!\Roblox\*" ".\data\roblox\"
	if exist ".\data\roblox\" rmdir /s /q "!LocalAppData!\Roblox\" else echo Nothing Was Copied From LocalAppData Something Is Wrong && pause && goto main
)
goto main

:dl
cls
echo ' Set your settings > .\bin\downloadwget.vbs
echo    strFileURL = "https://eternallybored.org/misc/wget/current/wget.exe" >> .\bin\downloadwget.vbs
echo    strHDLocation = "wget.exe" >> .\bin\downloadwget.vbs
echo. >> .\bin\downloadwget.vbs
echo ' Fetch the file >> .\bin\downloadwget.vbs
echo     Set objXMLHTTP = CreateObject("MSXML2.XMLHTTP") >> .\bin\downloadwget.vbs
echo. >> .\bin\downloadwget.vbs
echo     objXMLHTTP.open "GET", strFileURL, false >> .\bin\downloadwget.vbs
echo     objXMLHTTP.send() >> .\bin\downloadwget.vbs
echo. >> .\bin\downloadwget.vbs
echo If objXMLHTTP.Status = 200 Then >> .\bin\downloadwget.vbs
echo Set objADOStream = CreateObject("ADODB.Stream") >> .\bin\downloadwget.vbs
echo objADOStream.Open >> .\bin\downloadwget.vbs
echo objADOStream.Type = 1 'adTypeBinary >> .\bin\downloadwget.vbs
echo. >> .\bin\downloadwget.vbs
echo objADOStream.Write objXMLHTTP.ResponseBody >> .\bin\downloadwget.vbs
echo objADOStream.Position = 0    'Set the stream position to the start >> .\bin\downloadwget.vbs
echo. >> .\bin\downloadwget.vbs
echo Set objFSO = Createobject("Scripting.FileSystemObject") >> .\bin\downloadwget.vbs
echo If objFSO.Fileexists(strHDLocation) Then objFSO.DeleteFile strHDLocation >> .\bin\downloadwget.vbs
echo Set objFSO = Nothing >> .\bin\downloadwget.vbs
echo. >> .\bin\downloadwget.vbs
echo objADOStream.SaveToFile strHDLocation >> .\bin\downloadwget.vbs
echo objADOStream.Close >> .\bin\downloadwget.vbs
echo Set objADOStream = Nothing >> .\bin\downloadwget.vbs
echo End if >> .\bin\downloadwget.vbs
echo. >> .\bin\downloadwget.vbs
echo Set objXMLHTTP = Nothing >> .\bin\downloadwget.vbs
cscript.exe .\bin\downloadwget.vbs
move wget.exe .\bin\wget.exe

.\bin\wget.exe "https://www.roblox.com/download/client?os=win"
move "client@os=win" .\extra\RobloxPlayerInstaller.exe

.\extra\RobloxPlayerInstaller.exe

taskkill /f /im RobloxPlayerBeta.exe
taskkill /f /im RobloxPlayerInstaller.exe
taskkill /f /im RobloxStudioInstaller.exe
echo y | reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Uninstall\roblox-player
echo y | reg delete HKEY_CLASSES_ROOT\roblox
echo y | reg delete HKEY_CLASSES_ROOT\roblox-player
echo y | reg delete HKEY_CLASSES_ROOT\ROBLOX Corporation
if exist "!UserProfile!\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Roblox\" rmdir /s /q "!UserProfile!\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Roblox\"
if exist "!UserProfile!\Desktop\Roblox.lnk" del "!UserProfile!\Desktop\Roblox.lnk"
if exist "!UserProfile!\Desktop\Roblox Player.lnk" del "!UserProfile!\Desktop\Roblox Player.lnk"
if exist "!UserProfile!\Desktop\Roblox Studio.lnk" del "!UserProfile!\Desktop\Roblox Studio.lnk"

if exist "!LocalAppData!\Roblox\" (
	rmdir /s /q ".\data\roblox\"
	xcopy /e /i /y "!LocalAppData!\Roblox\*" ".\data\roblox\"
	if exist ".\data\roblox\" rmdir /s /q "!LocalAppData!\Roblox\" else echo Nothing Was Copied From LocalAppData Something Is Wrong && pause && goto main
)

goto main