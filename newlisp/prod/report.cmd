@echo off
:prep
cls
net use z: /delete
net use z: \\10.0.0.201\dosdat
ping 10.0.0.201 -n 5
dir z:\chp\*.dbf>nul
if ERRORLEVEL  1 goto:eof

:decl
set mypath=E:\sys
set mypy26=E:\Python26
set fdst=%mypath%\temp\

set /a mydate=%date:~8,2%%date:~3,2%%date:~0,2%-1                                      
rem set mydate=130930
echo %mydate%
set fsrc=z:\chp\lk%mydate%.dbf
if exist %fsrc% goto fcopy
set /a mydate=%mydate%-1
echo %mydate%
set fsrc=z:\chp\lk%mydate%.dbf
if exist %fsrc% goto fcopy
set /a mydate=%mydate%-1
echo %mydate%
set fsrc=z:\chp\lk%mydate%.dbf
if exist %fsrc% goto fcopy
goto final
exit

:fcopy
rem echo %mydate%
rem exit
xcopy /Y %fsrc% %fdst%
ping 10.0.0.201 -n 5

:main
set fsrc=%mypath%\temp\lk%mydate%.dbf
set fdst=%mypath%\temp\lk%mydate%-.dbf
del %fdst% /Q
%mypy26%\python %mypath%\dbf-encode.py -f UTF-8 -t CP1251 -n %fsrc% %fdst%
ping 10.0.0.201 -n 5

set fsrc=%mypath%\temp\lk%mydate%-.dbf
set fdst=%mypath%\temp\lk%mydate%-.txt
del %fdst% /Q
%mypy26%\python %mypath%\dbf-to-txt.py %fsrc% > %fdst%
rem start excel.exe %fdst%

cd e:\sys\blat
blat -body "BSU-5 report %mydate%" -to isf_39@mail.ru -subject "BSU-5 report %mydate%" -attach e:\sys\temp\lk%mydate%-.txt
blat -body "BSU-5 report %mydate%" -to tai10@bk.ru -subject "BSU-5 report %mydate%" -attach e:\sys\temp\lk%mydate%-.txt -attach e:\sys\temp\lk%mydate%-.dbf
blat -body "BSU-5 report %mydate%" -to tommy74y@gmail.com -subject "BSU-5 report %mydate%" -attach e:\sys\temp\lk%mydate%-.txt


:final
cd %mypath%
net use z: /delete
