# Repository Overview

## Project Description
- **What this project does**: Creates customizable 3D printable storage bins using OpenSCAD with rounded corners on both exterior and interior
- **Main purpose and goals**: Provide a parametric design system for generating storage bins of various sizes that are optimized for 3D printing
- **Key technologies used**: OpenSCAD (parametric CAD modeling), Bash scripting for batch processing, STL file format for 3D printing

## Architecture Overview
- **High-level architecture**: Single OpenSCAD model file with configurable parameters that can be rendered to STL format for 3D printing
- **Main components and their relationships**:
  - `simple bin.scad`: Core parametric model with customizable dimensions
  - `generate_bins.sh`: Batch processing script to create multiple bin variants
  - STL files: Exported 3D models ready for printing
- **Data flow and system interactions**: Parameters are defined in the SCAD file and can be overridden via command line to generate customized geometries which are then exported as STL files

## Directory Structure
- **Important directories and their purposes**: Root directory contains all source and output files
- **Key files and configuration**:
  - `simple bin.scad`: Main OpenSCAD model file with parametric definitions
  - `generate_bins.sh`: Bash script for batch generation of multiple bin sizes
  - `README.md`: Comprehensive documentation for the project
  - STL files: Pre-generated 3D models for common bin sizes
- **Entry points and main modules**:
  - `simple bin.scad`: Primary entry point for OpenSCAD modeling
  - `generate_bins.sh`: Entry point for batch processing

## Development Workflow
- **How to build/run the project**:
  1. Open `simple bin.scad` in OpenSCAD
  2. Modify parameters as needed
  3. Preview with F5 or render with F6
  4. Export as STL for 3D printing
  5. Alternatively, run `./generate_bins.sh` to batch generate predefined sizes
- **Testing approach**: Manual testing through OpenSCAD preview and render functions, with built-in sanity checks for parameter validation
- **Development environment setup**: Requires OpenSCAD (2021.01 or later recommended) and Bash shell for the generation script
- **Lint and format commands**: Not applicable for OpenSCAD files, but shell script follows standard bash practices