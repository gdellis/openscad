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
corner radius, floor thickness) from bin_specs.json and calls the OpenSCAD CLI for each entry.

Feel free to edit the bin_specs.json file to add/remove sizes.
-------------------------------------------------
"""

import subprocess
import sys
import os
import argparse
import json


# Configuration file
CONFIG_FILE = "bin_specs.json"
# Output directory
OUTPUT_DIR = "out"


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


def load_bin_specs(config_file):
    """
    Load bin specifications from a JSON configuration file.

    Expected format:
    {
      "bins": [
        {
          "name": "Bin description",
          "outer_width": number,
          "outer_depth": number,
          "height": number,
          "wall_thickness": number,
          "corner_radius": number,
          "floor_thickness": number
        },
        ...
      ]
    }

    Returns a list of tuples containing
    (outer_width, outer_depth, height, wall_thickness, corner_radius, floor_thickness).
    """
    if not os.path.isfile(config_file):
        print(f"Error: Configuration file {config_file} not found")
        sys.exit(1)

    try:
        with open(config_file, 'r') as f:
            config = json.load(f)
    except json.JSONDecodeError as e:
        print(f"Error: Invalid JSON in {config_file}: {e}")
        sys.exit(1)

    if "bins" not in config:
        print(f"Error: No 'bins' array found in {config_file}")
        sys.exit(1)

    specs = []
    for i, bin_spec in enumerate(config["bins"]):
        # Validate required fields
        required_fields = ["outer_width", "outer_depth", "height", "wall_thickness", "corner_radius", "floor_thickness"]
        missing_fields = [field for field in required_fields if field not in bin_spec]
        if missing_fields:
            print(f"Warning: Bin entry {i+1} missing required fields: {missing_fields}")
            continue

        # Extract values in the expected order
        spec_tuple = (
            bin_spec["outer_width"],
            bin_spec["outer_depth"],
            bin_spec["height"],
            bin_spec["wall_thickness"],
            bin_spec["corner_radius"],
            bin_spec["floor_thickness"]
        )
        specs.append(spec_tuple)

    if not specs:
        print(f"Error: No valid bin specifications found in {config_file}")
        sys.exit(1)

    return specs


def generate_stl(W, D, H, WT, CR, FT):
    """Generate a single STL file with given parameters."""
    # Ensure output directory exists
    os.makedirs(OUTPUT_DIR, exist_ok=True)

    # Build a clean output filename, e.g. bin_60x40x30.stl
    OUT = f"bin_{W}x{D}x{H}.stl"
    OUT_PATH = os.path.join(OUTPUT_DIR, OUT)

    print(f"Generating {OUT} (W={W}, D={D}, H={H})...")

    try:
        subprocess.run(
            [
                "openscad",
                "-o",
                OUT_PATH,
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
            print(f"Custom bin {W}x{D}x{H} generated successfully in '{OUTPUT_DIR}' directory.")
        else:
            sys.exit(1)

    else:
        # Generate all predefined bins
        print("Loading bin specifications from", CONFIG_FILE)
        bin_specs = load_bin_specs(CONFIG_FILE)
        print(f"Generating {len(bin_specs)} predefined bin sizes in '{OUTPUT_DIR}' directory...")
        all_success = True

        for spec in bin_specs:
            # Unpack the spec tuple into individual variables
            W, D, H, WT, CR, FT = spec

            success = generate_stl(W, D, H, WT, CR, FT)
            if not success:
                all_success = False

        if all_success:
            print(f"All bins generated successfully in '{OUTPUT_DIR}' directory.")
        else:
            sys.exit(1)


if __name__ == "__main__":
    main()
