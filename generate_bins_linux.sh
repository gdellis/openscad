#!/bin/bash
# generate_bins_linux.sh
# -------------------------------------------------
# Linux launcher for the parametric bin generator.
#
# This script runs the Python generation script (generate_bins.py)
# to create STL files for multiple bin sizes.
#
# Requirements:
# - Python 3.x installed and in PATH
# - OpenSCAD installed and in PATH
# -------------------------------------------------

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ---- Error handling -----------------
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}Error:${NC} Python 3 is not installed or not in PATH"
    echo "Please install Python 3.x and make sure it's in your PATH"
    exit 1
fi

if ! command -v openscad &> /dev/null; then
    echo -e "${RED}Error:${NC} OpenSCAD is not installed or not in PATH"
    echo "Please install OpenSCAD and make sure it's in your PATH"
    exit 1
fi

if [ ! -f "generate_bins.py" ]; then
    echo -e "${RED}Error:${NC} generate_bins.py not found"
    echo "Please make sure you're running this script from the correct directory"
    exit 1
fi

if [ ! -f "simple bin.scad" ]; then
    echo -e "${RED}Error:${NC} simple bin.scad not found"
    echo "Please make sure you're running this script from the correct directory"
    exit 1
fi

# ---- Run the Python script ---------------
echo -e "${BLUE}Running Python bin generator script...${NC}"
python3 generate_bins.py

if [ $? -eq 0 ]; then
    echo -e "${GREEN}All bins generated successfully!${NC}"
else
    echo -e "${RED}Error occurred while generating bins.${NC}"
    exit $?
fi
