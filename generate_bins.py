#!/usr/bin/env python3
"""
generate_bins.py
-------------------------------------------------
Batch-generate STL files for the parametric bin model.

Usage:
  ./generate_bins.py            # creates a set of STL files in the current directory

The script reads a list of specifications (width, depth, height, wall thickness,
corner radius, floor thickness) and calls the OpenSCAD CLI for each entry.

Feel free to edit the "specs" list to add/remove sizes.
-------------------------------------------------
"""

import subprocess
import sys
import os


# ---- Error handling -----------------
# Check if OpenSCAD is installed
def check_openscad():
    try:
        subprocess.run(
            ["openscad", "--version"],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            check=True,
        )
        return True
    except (subprocess.CalledProcessError, FileNotFoundError):
        return False


# Check if SCAD file exists
SCAD_FILE = "simple bin.scad"
if not os.path.isfile(SCAD_FILE):
    print(f"Error: {SCAD_FILE} not found")
    sys.exit(1)

if not check_openscad():
    print("Error: OpenSCAD is not installed or not in PATH")
    sys.exit(1)

# ---- Define the list of bin specifications -----------------
# Format: (outer_width, outer_depth, height, wall_thickness, corner_radius, floor_thickness)
specs = [
    (60, 40, 30, 1.6, 5, 1.6),  # Small bin
    (80, 60, 40, 2, 8, 2),  # Medium bin
    (100, 80, 50, 2.5, 10, 2.5),  # Large bin
    (120, 100, 60, 3, 12, 3),  # Extra-large bin
    (180, 120, 80, 3, 15, 3),  # Jumbo bin
]

# ---- Loop over each spec and generate the STL ---------------
for spec in specs:
    # Unpack the spec tuple into individual variables
    W, D, H, WT, CR, FT = spec

    # Build a clean output filename, e.g. bin_60x40x30.stl
    OUT = f"bin_{W}x{D}x{H}.stl"

    print(f"Generating {OUT} (W={W}, D={D}, H={H})...")

    try:
        subprocess.run(
            [
                "openscad",
                "-o",
                OUT,
                f"-D outer_width={W}",
                f"-D outer_depth={D}",
                f"-D height={H}",
                f"-D wall_thickness={WT}",
                f"-D corner_radius={CR}",
                f"-D floor_thickness={FT}",
                SCAD_FILE,
            ],
            check=True,
        )
    except subprocess.CalledProcessError:
        print(f"Error: Failed to generate {OUT}")
        sys.exit(1)

print("All bins generated successfully.")
