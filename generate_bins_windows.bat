@echo off
REM generate_bins_windows.bat
REM -------------------------------------------------
REM Windows launcher for the parametric bin generator.
REM
REM This script runs the Python generation script (generate_bins.py)
REM to create STL files for multiple bin sizes.
REM
REM Requirements:
REM - Python 3.x installed and in PATH
REM - OpenSCAD installed and in PATH
REM -------------------------------------------------

REM ---- Error handling -----------------
where python >nul 2>nul
if %errorlevel% neq 0 (
    echo Error: Python is not installed or not in PATH
    echo Please install Python 3.x and make sure it's in your system PATH
    pause
    exit /b 1
)

where openscad >nul 2>nul
if %errorlevel% neq 0 (
    echo Error: OpenSCAD is not installed or not in PATH
    echo Please install OpenSCAD and make sure it's in your system PATH
    pause
    exit /b 1
)

if not exist "generate_bins.py" (
    echo Error: generate_bins.py not found
    echo Please make sure you're running this script from the correct directory
    pause
    exit /b 1
)

if not exist "simple bin.scad" (
    echo Error: simple bin.scad not found
    echo Please make sure you're running this script from the correct directory
    pause
    exit /b 1
)

REM ---- Run the Python script ---------------
echo Running Python bin generator script...
python generate_bins.py

if %errorlevel% equ 0 (
    echo.
    echo All bins generated successfully!
) else (
    echo.
    echo Error occurred while generating bins.
    exit /b %errorlevel%
)

pause
