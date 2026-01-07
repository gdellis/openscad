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

### Using Python Script (Primary Method)

The Python script is now the primary and recommended way to generate STL files:

```bash
# Generate all predefined bin sizes (defined in bin_specs.json)
# STL files will be placed in the 'out' directory
./generate_bins.py

# Generate a custom sized bin with default parameters
# STL file will be placed in the 'out' directory
./generate_bins.py --custom 100 80 50

# Generate a custom sized bin with all parameters specified
# STL file will be placed in the 'out' directory
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

The Python generation script (`generate_bins.py`) is the primary and recommended way to generate bins, as it works across all platforms and offers the most flexibility:

* Works on Windows, macOS, and Linux
* Supports both batch generation and custom sizing
* Includes robust error handling
* Can be used programmatically
* Uses external JSON configuration file for predefined bins
* Automatically creates `out` directory for generated STL files

### Requirements for Python Script

* Python 3.x installed
* OpenSCAD installed and in system PATH
* All requirements listed above for the main project

### Why Use the Python Script?

The Python script replaces the older bash and batch scripts with a single, cross-platform solution that:
* Works consistently across all operating systems
* Provides better error handling and validation
* Offers both batch generation and custom sizing options
* Automatically organizes output in the `out` directory
* Is more maintainable and extensible

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
