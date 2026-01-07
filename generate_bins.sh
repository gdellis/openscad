#!/usr/bin/env bash
# generate_bins.sh
# -------------------------------------------------
# Batch‑generate STL files for the parametric bin model.
#
# Usage:
#   ./generate_bins.sh            # creates a set of STL files in the current directory
#
# The script reads a list of specifications (width, depth, height, wall thickness,
# corner radius, floor thickness) and calls the OpenSCAD CLI for each entry.
#
# Feel free to edit the "specs" array to add/remove sizes.
# -------------------------------------------------

# ---- Error handling -----------------
# Check if OpenSCAD is installed
if ! command -v openscad &> /dev/null; then
    echo "Error: OpenSCAD is not installed or not in PATH"
    exit 1
fi

# Check if SCAD file exists
SCAD_FILE="simple bin.scad"
if [ ! -f "$SCAD_FILE" ]; then
    echo "Error: $SCAD_FILE not found"
    exit 1
fi

# ---- Define the list of bin specifications -----------------
# Format:  "outer_width outer_depth height wall_thickness corner_radius floor_thickness"
specs=(
    "60 40 30 1.6 5 1.6"   # Small bin
    "80 60 40 2 8 2"       # Medium bin
    "100 80 50 2.5 10 2.5" # Large bin
    "120 100 60 3 12 3"    # Extra‑large bin
    "180 120 80 3 15 3"    # Jumbo bin
)

# ---- Loop over each spec and generate the STL ---------------
for spec in "${specs[@]}"; do
    # Split the spec string into individual variables
    read -r W D H WT CR FT <<< "$spec"

    # Build a clean output filename, e.g. bin_60x40x30.stl
    OUT="bin_${W}x${D}x${H}.stl"

    echo "Generating $OUT (W=${W}, D=${D}, H=${H})..."

    openscad -o "$OUT" \
        -D "outer_width=$W" \
        -D "outer_depth=$D" \
        -D "height=$H" \
        -D "wall_thickness=$WT" \
        -D "corner_radius=$CR" \
        -D "floor_thickness=$FT" \
        "$SCAD_FILE"
done

echo "All bins generated successfully."
