@echo off
REM generate_bins_windows.bat
REM -------------------------------------------------
REM Batch-generate STL files for the parametric bin model (Windows version).
REM
REM Usage:
REM   generate_bins_windows.bat            # creates a set of STL files in the current directory
REM
REM The script reads a list of specifications (width, depth, height, wall thickness,
REM corner radius, floor thickness) and calls the OpenSCAD CLI for each entry.
REM
REM Feel free to edit the "specs" section to add/remove sizes.
REM -------------------------------------------------

REM ---- Error handling -----------------
where openscad >nul 2>nul
if %errorlevel% neq 0 (
    echo Error: OpenSCAD is not installed or not in PATH
    echo Please install OpenSCAD and make sure it's in your system PATH
    pause
    exit /b 1
)

if not exist "simple bin.scad" (
    echo Error: simple bin.scad not found
    pause
    exit /b 1
)

REM ---- Define the list of bin specifications -----------------
REM Format: width depth height wall_thickness corner_radius floor_thickness
REM Note: We'll use a different approach in Windows batch

REM ---- Generate STL files for each specification ---------------
echo Generating Small bin (60x40x30)...
openscad -o bin_60x40x30.stl ^
    -D "outer_width=60" ^
    -D "outer_depth=40" ^
    -D "height=30" ^
    -D "wall_thickness=1.6" ^
    -D "corner_radius=5" ^
    -D "floor_thickness=1.6" ^
    "simple bin.scad"

echo Generating Medium bin (80x60x40)...
openscad -o bin_80x60x40.stl ^
    -D "outer_width=80" ^
    -D "outer_depth=60" ^
    -D "height=40" ^
    -D "wall_thickness=2" ^
    -D "corner_radius=8" ^
    -D "floor_thickness=2" ^
    "simple bin.scad"

echo Generating Large bin (100x80x50)...
openscad -o bin_100x80x50.stl ^
    -D "outer_width=100" ^
    -D "outer_depth=80" ^
    -D "height=50" ^
    -D "wall_thickness=2.5" ^
    -D "corner_radius=10" ^
    -D "floor_thickness=2.5" ^
    "simple bin.scad"

echo Generating Extra-large bin (120x100x60)...
openscad -o bin_120x100x60.stl ^
    -D "outer_width=120" ^
    -D "outer_depth=100" ^
    -D "height=60" ^
    -D "wall_thickness=3" ^
    -D "corner_radius=12" ^
    -D "floor_thickness=3" ^
    "simple bin.scad"

echo Generating Jumbo bin (180x120x80)...
openscad -o bin_180x120x80.stl ^
    -D "outer_width=180" ^
    -D "outer_depth=120" ^
    -D "height=80" ^
    -D "wall_thickness=3" ^
    -D "corner_radius=15" ^
    -D "floor_thickness=3" ^
    "simple bin.scad"

echo All bins generated successfully.
pause
