# OpenCV-InstallScript

A small command line installer for building OpenCV on windows with [Git Bash](https://git-scm.com/) and [CMake](https://github.com/Kitware/CMake). 

Change C:\lib\Install\opencv\x64\vc15 (line [62](https://github.com/RaymondKirk/OpenCV-InstallScript/blob/master/install_opencv.bat#L62) and [63](https://github.com/RaymondKirk/OpenCV-InstallScript/blob/master/install_opencv.bat#L63)) and CMAKE_CONFIG_GENERATOR (line [24](https://github.com/RaymondKirk/OpenCV-InstallScript/blob/master/install_opencv.bat#L24)) to match the generator you will be using (default is VS2017).

## Installation
Copy and paste the commands into command prompt.
```bash
git clone https://github.com/RaymondKirk/OpenCV-InstallScript.git
OpenCV-InstallScript\install_opencv.bat
```