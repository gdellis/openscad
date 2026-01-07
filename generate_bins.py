#!/usr/bin/env python3
"""
generate_bins.py
-------------------------------------------------
Batch-generate STL files for the parametric bin model.

Usage:
  ./generate_bins.py                          # Generate predefined bin sizes
  ./generate_bins.py --custom WIDTH DEPTH HEIGHT [WALL_THICKNESS CORNER_RADIUS FLOOR_THICKNESS]
                                              # Generate a custom sized bin
  
Examples:
  ./generate_bins.py                          # Generate all predefined bins
  ./generate_bins.py --custom 100 80 50       # Generate a 100x80x50 bin with default parameters
  ./generate_bins.py --custom 100 80 50 2 10 2 # Generate a 100x80x50 bin with custom parameters

The script reads a list of specifications (width, depth, height, wall thickness,
corner radius, floor thickness) and calls the OpenSCAD CLI for each entry.

Feel free to edit the "specs" list to add/remove sizes.
-------------------------------------------------
"""

import subprocess
import sys
import os
import argparse


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
DEFAULT_SPECS = [
    (60, 40, 30, 1.6, 5, 1.6),  # Small bin
    (80, 60, 40, 2, 8, 2),  # Medium bin
    (100, 80, 50, 2.5, 10, 2.5),  # Large bin
    (120, 100, 60, 3, 12, 3),  # Extra-large bin
    (180, 120, 80, 3, 15, 3),  # Jumbo bin
]


def generate_stl(W, D, H, WT, CR, FT):
    """Generate a single STL file with given parameters."""
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
        return True
    except subprocess.CalledProcessError:
        print(f"Error: Failed to generate {OUT}")
        return False


def main():
    parser = argparse.ArgumentParser(description="Generate 3D printable bin STL files.")
    parser.add_argument(
        "--custom",
        nargs="*",
        type=float,
        help="Generate a custom sized bin. Provide 3, 4, 5, or 6 values: "
             "WIDTH DEPTH HEIGHT [WALL_THICKNESS CORNER_RADIUS FLOOR_THICKNESS]. "
             "Missing parameters will use default values."
    )
    
    args = parser.parse_args()

    if args.custom is not None:
        # Handle custom bin generation
        num_custom_params = len(args.custom)
        
        if num_custom_params < 3:
            print("Error: At least 3 parameters required for --custom option")
            print("Usage: --custom WIDTH DEPTH HEIGHT [WALL_THICKNESS CORNER_RADIUS FLOOR_THICKNESS]")
            sys.exit(1)
        
        if num_custom_params > 6:
            print("Error: Maximum 6 parameters allowed for --custom option")
            sys.exit(1)
        
        # Extract provided parameters
        W = args.custom[0]
        D = args.custom[1]
        H = args.custom[2]
        WT = args.custom[3] if num_custom_params > 3 else 2.0  # Default wall thickness
        CR = args.custom[4] if num_custom_params > 4 else 10.0  # Default corner radius
        FT = args.custom[5] if num_custom_params > 5 else 2.0  # Default floor thickness
        
        # Generate the custom bin
        success = generate_stl(W, D, H, WT, CR, FT)
        if success:
            print(f"Custom bin {W}x{D}x{H} generated successfully.")
        else:
            sys.exit(1)
            
    else:
        # Generate all predefined bins
        print("Generating predefined bin sizes...")
        all_success = True
        
        for spec in DEFAULT_SPECS:
            # Unpack the spec tuple into individual variables
            W, D, H, WT, CR, FT = spec
            
            success = generate_stl(W, D, H, WT, CR, FT)
            if not success:
                all_success = False
                
        if all_success:
            print("All bins generated successfully.")
        else:
            sys.exit(1)


if __name__ == "__main__":
    main()
