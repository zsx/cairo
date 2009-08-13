@echo off
set RELEASE_PATH=%~dp0\..\Win32\Release
%OAH_INSTALLED_PATH%\bin\pkg-config --modversion %RELEASE_PATH%\lib\pkgconfig\cairo.pc > libver.tmp || goto error
set /P LIBVER= < libver.tmp
del libver.tmp

nmake /nologo version=%LIBVER% release_path=%RELEASE_PATH% %*

goto:eof
:error
echo Couldn't start build process... are pkg-config in your PATH and/or have you compiled cairo.sln with OAH_BUILD_OUTPUT cleared!??