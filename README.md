# Simple Parametric Bin - OpenSCAD

A customizable 3D printable rectangular bin with rounded corners on both the exterior and interior.

## Overview

This OpenSCAD project generates a parametric storage bin that can be easily customized to any size. The bin features rounded corners on both the outside for aesthetics and the inside for easy cleaning, making it perfect for organizing small parts, tools, or other items.

## Features

- **Fully Parametric**: Easily adjust all dimensions through simple variables
- **Rounded Corners**: Smooth corners on both exterior and interior
- **Built-in Sanity Checks**: Validates parameters to prevent impossible geometry
- **Optimized for 3D Printing**: Print-ready design with proper wall thickness
- **Customizable Wall & Floor Thickness**: Adjust strength as needed

## Requirements

- [OpenSCAD](https://openscad.org/) (2021.01 or later recommended)
- Basic knowledge of OpenSCAD for customization

## Default Parameters

```openscad
outer_width = 120;      // Outer width in mm
outer_depth = 80;       // Outer depth in mm  
height = 50;            // Total height in mm
wall_thickness = 2;     // Wall thickness in mm
corner_radius = 10;     // Corner radius in mm
floor_thickness = 2;    // Floor thickness in mm
convexity = 10;         // Preview rendering quality
```

## Customization

### Key Parameters

| Parameter | Description | Recommended Range |
|-----------|-------------|-------------------|
| `outer_width` | Overall width of the bin (mm) | 40-200+ |
| `outer_depth` | Overall depth of the bin (mm) | 40-200+ |
| `height` | Total height of the bin (mm) | 20-100+ |
| `wall_thickness` | Thickness of walls (mm) | 1.2-5+ |
| `corner_radius` | Radius of rounded corners (mm) | 2-30+ |
| `floor_thickness` | Thickness of the floor (mm) | 1.2-5+ |

### Customization Examples

**Small Parts Bin:**
```openscad
outer_width = 60;
outer_depth = 40;
height = 30;
wall_thickness = 1.6;
corner_radius = 5;
```

**Large Storage Bin:**
```openscad
outer_width = 180;
outer_depth = 120;
height = 80;
wall_thickness = 3;
corner_radius = 15;
```

**Heavy-Duty Bin:**
```openscad
outer_width = 100;
outer_depth = 100;
height = 60;
wall_thickness = 4;
floor_thickness = 4;
corner_radius = 10;
```

## How to Use

1. **Open in OpenSCAD**: Launch OpenSCAD and open `simple bin.scad`

2. **Customize Parameters**: Modify the variables at the top of the file to your desired dimensions

3. **Preview**: Press `F5` or click "Preview" to see a quick render

4. **Render**: Press `F6` or click "Render" to generate the final geometry

5. **Export**: Go to `File > Export > Export as STL...` to save for 3D printing

### Using Makefile (Alternative Method)

If you have `make` installed, you can use the provided Makefile for easier building:

```bash
# Build a bin with default parameters
make

# Build a bin with custom parameters
make OUTER_WIDTH=100 OUTER_DEPTH=100 HEIGHT=60

# Batch generate all predefined bins
make batch

# Preview in OpenSCAD GUI
make preview

# Clean generated STL files
make clean
```

### Using Python Script (Alternative Method)

The Python script provides the most flexibility with command line options:

```bash
# Generate all predefined bin sizes (defined in bin_specs.json)
./generate_bins.py

# Generate a custom sized bin with default parameters
./generate_bins.py --custom 100 80 50

# Generate a custom sized bin with all parameters specified
./generate_bins.py --custom 100 80 50 2 10 2
```

Valid parameters for `--custom` are:
- WIDTH (mm)
- DEPTH (mm)
- HEIGHT (mm)
- WALL_THICKNESS (mm, default: 2.0)
- CORNER_RADIUS (mm, default: 10.0)
- FLOOR_THICKNESS (mm, default: 2.0)

Feel free to modify `bin_specs.json` to customize the predefined bin sizes without editing the script.

---

## Batch Generation with Bash Script

A helper script `generate_bins.sh` is provided to automatically create STL files for multiple bin sizes.

### What the script does
* Reads bin specifications from `bin_specs.json`
* Loops over each specification and builds a descriptive output filename (e.g., `bin_60x40x30.stl`).
* Calls the OpenSCAD CLI with `-D` flags to override the parameters in `simple bin.scad`.
* Generates ready‑to‑print STL files for every entry.

### Usage
```bash
# Make the script executable (once)
chmod +x generate_bins.sh

# Run the script – it will create several STL files in the current directory
./generate_bins.sh
```

You can edit the `bin_specs.json` file to add or remove bin sizes. Each entry follows the format:
```
{
  "name": "Bin description",
  "outer_width": number,
  "outer_depth": number,
  "height": number,
  "wall_thickness": number,
  "corner_radius": number,
  "floor_thickness": number
}
```

### Example output files
After running the script you will find files such as:
* `bin_60x40x30.stl` – Small bin (60 × 40 × 30 mm)
* `bin_80x60x40.stl` – Medium bin
* `bin_100x80x50.stl` – Large bin
* `bin_120x100x60.stl` – Extra‑large bin
* `bin_180x120x80.stl` – Jumbo bin

These STL files can be sliced directly with your favourite slicer and printed.

---

## Using Makefile

A Makefile is provided for easier building and management of the project. The Makefile supports:

* Building individual bins with custom parameters
* Batch generation of all predefined bins
* Previewing models in OpenSCAD GUI
* Cleaning generated files

### Requirements for Makefile

* Unix-like environment with `make` command
* All requirements listed above for the main project

---

## Using Python Script

The Python generation script (`generate_bins.py`) is now the recommended way to generate bins, as it works across all platforms and offers the most flexibility:

* Works on Windows, macOS, and Linux
* Supports both batch generation and custom sizing
* Includes robust error handling
* Can be used programmatically
* Uses external JSON configuration file for predefined bins

### Requirements for Python Script

* Python 3.x installed
* OpenSCAD installed and in system PATH
* All requirements listed above for the main project

---

## Sanity Checks

The design includes built‑in validation that will alert you if:
- Any dimension is zero or negative
- Corner radius is too large for the bin dimensions
- Wall thickness is too large for the bin dimensions
- Any other impossible geometry is detected

## 3D Printing Tips

- **Orientation**: Print with the open face up (no support needed)
- **Layer Height**: 0.2mm works well for most bins
- **Wall Thickness**: Minimum 1.2mm for 0.4mm nozzle (3 perimeters)
- **Infill**: 15-20% infill is usually sufficient for storage bins
- **Material**: PLA, PETG, or ABS all work well
- **Corner Radius**: Larger radii (10mm+) print more reliably than small sharp corners

## Design Details

### Inner Dimensions Calculation

The script automatically calculates inner dimensions:
- `inner_width = outer_width - 2 × wall_thickness`
- `inner_depth = outer_depth - 2 × wall_thickness`
- `inner_height = height - floor_thickness`

### Module Structure

- **RoundedRectangle**: 2D rounded rectangle generator
- **Bin**: Main bin geometry using constructive solid geometry
- **SanityCheck**: Parameter validation module
