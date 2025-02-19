@ECHO OFF

if not exist .ci (cd ..)
if not exist .ci exit /b 1

SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

echo Compiling new QB64
if defined APPVEYOR_REPO_COMMIT (echo From git %APPVEYOR_REPO_COMMIT:~0,7% > internal\version.txt)
qb64_bootstrap.exe -z source\qb64.bas
cd internal\c
c_compiler\bin\g++ -mconsole -s -Wfatal-errors -w -Wall qbx.cpp libqb\os\win\libqb_setup.o ..\temp\icon.o -D DEPENDENCY_LOADFONT  parts\video\font\ttf\os\win\src.o -D DEPENDENCY_SOCKETS -D DEPENDENCY_NO_PRINTER -D DEPENDENCY_ICON -D DEPENDENCY_NO_SCREENIMAGE parts\core\os\win\src.a -lopengl32 -lglu32   -mwindows -static-libgcc -static-libstdc++ -D GLEW_STATIC -D FREEGLUT_STATIC     -lws2_32 -lwinmm -lgdi32 -o "..\..\qb64.exe"
IF ERRORLEVEL 1 exit /b 1

cd ..\..
del qb64_bootstrap.exe
del /q /s secure-file
del /q /s internal\source\*
move internal\temp\* internal\source\
del /q /s internal\c\libqb\*.o >nul 2>nul
del /q /s internal\c\libqb\*.a >nul 2>nul
del /q /s internal\c\parts\*.o >nul 2>nul
del /q /s internal\c\parts\*.a >nul 2>nul
cd internal\source
del /q /s debug_* recompile_*
