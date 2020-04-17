@echo off
set "ScriptDir=%cd%"
REG QUERY "HKEY_LOCAL_MACHINE\Software\BlueStacks_bgp64">nul
if %ERRORLEVEL% EQU 1 goto NOTBGP64
FOR /F "usebackq tokens=2,* skip=2" %%A IN (`REG QUERY "HKEY_LOCAL_MACHINE\Software\BlueStacks_bgp64" /v InstallDir`) DO (
    set "AppDir=%%B"
    )
cd %AppDir%
echo Processing Bluestacks installation in: %AppDir%
echo Quitting Bluestacks and killing tasks...
HD-Quit.exe
taskkill /f /im Bluestacks.exe >nul 2>nul && (
  echo Bluestacks.exe was killed.
) || (
  echo Bluestacks does not seem to be running.
)
taskkill /f /im BstkSVC.exe >nul 2>nul && (
  echo BstkSVC.exe was killed.
) || (
  echo Bluestacks Server Interface does not seem to be running.
)
taskkill /f /im HD-Agent.exe >nul 2>nul && (
  echo HD-Agent.exe was killed.
) || (
  echo Bluestacks Agent does not seem to be running.
)

FOR /F "usebackq tokens=2,* skip=2" %%A IN (`REG QUERY "HKEY_LOCAL_MACHINE\Software\BlueStacks_bgp64" /v DataDir`) DO (
    set "BstkDir=%%BAndroid"
    )
cd %BstkDir%
echo Making backup copy of Android.bstk
copy Android.bstk Android.bstk.BACKUP
echo Done!
cd %ScriptDir%
echo Modifying Android.bstk...
xml ed -L -N N="http://www.virtualbox.org/" --update "//N:SharedFolder[@name='Documents']/@hostPath" --value "None" %BstkDir%\Android.bstk
xml ed -L -N N="http://www.virtualbox.org/" --update "//N:SharedFolder[@name='Pictures']/@hostPath" --value "None" %BstkDir%\Android.bstk
xml ed -L -N N="http://www.virtualbox.org/" --update "//N:SharedFolder[@name='Documents']/@writable" --value "false" %BstkDir%\Android.bstk
xml ed -L -N N="http://www.virtualbox.org/" --update "//N:SharedFolder[@name='Pictures']/@writable" --value "false" %BstkDir%\Android.bstk
echo Done!
cd %ScriptDir%
echo Backing up BlueStacks registry...
REG EXPORT "HKEY_LOCAL_MACHINE\Software\BlueStacks_bgp64" BlueStacks_bgp64-RegistryBackup.reg
echo Done!
echo Modifying registry entries...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\BlueStacks_bgp64\Guests\Android\SharedFolder\1" /v Writable /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\BlueStacks_bgp64\Guests\Android\SharedFolder\1" /v Path /t REG_SZ /d "" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\BlueStacks_bgp64\Guests\Android\SharedFolder\2" /v Writable /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\BlueStacks_bgp64\Guests\Android\SharedFolder\2" /v Path /t REG_SZ /d "" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\BlueStacks_bgp64\Guests\Android\SharedFolder\3" /v Writable /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\BlueStacks_bgp64\Guests\Android\SharedFolder\3" /v Path /t REG_SZ /d "" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\BlueStacks_bgp64\Guests\Android\SharedFolder\4" /v Writable /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\BlueStacks_bgp64\Guests\Android\SharedFolder\4" /v Path /t REG_SZ /d "" /f
echo Done! Thanks for using my script. :)
goto END

:NOTBGP64
echo It seems like you don't have 64-bit Android Bluestacks installed.
echo Exiting...
goto END

:END
pause