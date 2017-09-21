@echo off
REM Installation script for OpenCV using GitBash 
REM   Change C:\lib\Install\opencv\x64\vc15 (line 62 and 63) and CMAKE_CONFIG_GENERATOR (line 24)
REM   to match the generator you will be using.

REM Elevate prompt for writing system enviroment files and in some cases local files
if not "%1"=="am_admin" (powershell start -verb runas '%0' am_admin & exit)

REM Must have downloaded and installed CMake>=3.9.1 and Git-Bash>=2.14.1
git.exe --version > nul
if not %ERRORLEVEL%==9009 (echo Git exists in path) else (echo Git is not in the system path exiting && goto EOF)
cmake.exe --version > nul
if not %ERRORLEVEL%==9009 (echo CMake exists in path) else (echo CMake is not in the system path exiting && goto EOF)

REM Create standard installation directory
set filename=installOCV.sh
if not exist "C:\lib\" (mkdir C:\lib) else (echo Directory already exists)
cd C:\lib

REM Write bash script to directory for exectution
REM from http://docs.opencv.org/master/d3/d52/tutorial_windows_install.html#tutorial_windows_install_path
>%filename% echo #!/bin/bash -e
>>%filename% echo myRepo=$(pwd)
>>%filename% echo CMAKE_CONFIG_GENERATOR="Visual Studio 15 2017 Win64"
>>%filename% echo if [  ! -d "$myRepo/opencv"  ]; then
>>%filename% echo     echo "Cloning opencv"
>>%filename% echo     git clone https://github.com/opencv/opencv.git
>>%filename% echo     mkdir -p Build/opencv
>>%filename% echo     mkdir -p Install/opencv
>>%filename% echo else
>>%filename% echo     cd opencv
>>%filename% echo     git pull --rebase
>>%filename% echo     cd ..
>>%filename% echo fi
>>%filename% echo if [  ! -d "$myRepo/opencv_contrib"  ]; then
>>%filename% echo     echo "Cloning opencv_contrib"
>>%filename% echo     git clone https://github.com/opencv/opencv_contrib.git
>>%filename% echo     mkdir -p Build/opencv_contrib
>>%filename% echo else
>>%filename% echo     cd opencv_contrib
>>%filename% echo     git pull --rebase
>>%filename% echo     cd ..
>>%filename% echo fi
>>%filename% echo RepoSource=opencv
>>%filename% echo pushd Build/$RepoSource
>>%filename% echo CMAKE_OPTIONS='-DBUILD_PERF_TESTS:BOOL=OFF -DBUILD_TESTS:BOOL=OFF -DBUILD_DOCS:BOOL=OFF -DBUILD_EXAMPLES:BOOL=OFF -DINSTALL_CREATE_DISTRIB=ON'
>>%filename% echo cmake -G"$CMAKE_CONFIG_GENERATOR" $CMAKE_OPTIONS -DOPENCV_EXTRA_MODULES_PATH="$myRepo"/opencv_contrib/modules -DCMAKE_INSTALL_PREFIX="$myRepo"/install/"$RepoSource" "$myRepo/$RepoSource"
>>%filename% echo echo "************************* $Source_DIR -->debug"
>>%filename% echo cmake --build .  --config debug
>>%filename% echo echo "************************* $Source_DIR -->release"
>>%filename% echo cmake --build .  --config release
>>%filename% echo cmake --build .  --target install --config release
>>%filename% echo cmake --build .  --target install --config debug
>>%filename% echo popd
>>%filename% echo echo "Closing in 3 seconds"
>>%filename% echo sleep 3

REM Start build process in background with git-bash
start %filename%

REM Set system enviroment variable and path
setx OPENCV_DIR C:\lib\Install\opencv\x64\vc15 /M
if "%PATH:C:\lib\Install\opencv\x64\vc15=%"=="%PATH%" (
echo Adding OpenCV binaries to system path
setx PATH "%PATH%;%OPENCV_DIR%\bin" /M
) else (echo OpenCV binaries already exist in system path)

:EOF
PAUSE