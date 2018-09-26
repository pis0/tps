set "variable=%1"
set "variable=%variable:\=/%"
echo %variable%
start C:\cygwin64\bin\sh.exe -li C:/workspace/tps/tps.sh %variable%