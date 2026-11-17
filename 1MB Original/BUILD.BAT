cls
set path=%path%;c:\bin
set sasmheap=14400
cd sf2
del *.sob
make
copy sg.rom ..\sg.sfc
cd ..
extend sg.sfc 8 ff
sfcheck -s -f sg.sfc
pause
exit
