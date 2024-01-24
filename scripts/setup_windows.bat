set "bin_loc=C:\Program Files\dreamengine\bin"
set "exec_loc=%1\dreamengine.bat"

mkdir "%bin_loc%"
copy "%exec_loc%" "%bin_loc%dreamengine.bat"

echo %PATH% | find /I "%bin_loc%" > nul
if errorlevel 1 (
    setx /M PATH "%PATH%;%bin_loc%" 
)

PAUSE 1