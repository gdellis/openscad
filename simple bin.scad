// rectangular_bin_with_rounded_corners.scad
// A parametric rectangular bin with rounded corners on both inside and outside.
// Author: Glenn Ellis
// Date: 2025-01-06
// Updated: 2026-01-07 - Added stacking features and improved 3D printing constraints

// Exposed parameters with units and recommended ranges:
//   outer_width       - total outer width of the bin (mm) [40-200+]
//   outer_depth       - total outer depth of the bin (mm) [40-200+]
//   height            - total height of the bin (mm) [20-100+]
//   wall_thickness    - thickness of the walls (mm) [1.2-5+] (min 1.2mm for 0.4mm nozzle)
//   corner_radius     - radius of the rounded corners (mm) [2-30+] (larger radii print more reliably)
//   floor_thickness   - thickness of the floor (mm) [1.2-5+] (min 1.2mm for 0.4mm nozzle)
//   stacking_lip      - height of the stacking lip (mm) [0-10] (0 to disable)
//   convexity         - convexity parameter for preview rendering [10 is safe default]

outer_width = 120;      // Outer width in mm
outer_depth = 80;       // Outer depth in mm
height = 50;            // Total height in mm
wall_thickness = 2;     // Wall thickness in mm (min 1.2mm for 0.4mm nozzle)
corner_radius = 10;     // Corner radius in mm (larger radii print more reliably)
floor_thickness = 2;    // Floor thickness in mm (min 1.2mm for 0.4mm nozzle)
stacking_lip = 2;       // Stacking lip height in mm (0 to disable)
convexity = 10;         // Safe default for preview

// Derived dimensions
inner_width = outer_width - 2 * wall_thickness;
inner_depth = outer_depth - 2 * wall_thickness;
inner_height = height - floor_thickness;

module RoundedRectangle(width, depth, radius, center = false) {
    // Create a 2D rounded rectangle with given dimensions and corner radius
    // Using hull() with circles at corners instead of minkowski for better performance
    // Minkowski can be very slow for complex operations despite producing similar results
    translate(center ? [-width/2, -depth/2] : [0, 0])
        hull() {
            for (x = [0, 1], y = [0, 1])
                translate([x ? width - radius : radius,
                           y ? depth - radius : radius])
                    circle(r = radius, $fn = 32);
        }
}

module Bin() {
    union() {
        difference() {
            // Outer shell with rounded corners
            linear_extrude(height = height, convexity = convexity)
                RoundedRectangle(outer_width, outer_depth, corner_radius);

            // Inner cavity with rounded corners
            translate([wall_thickness, wall_thickness, floor_thickness])
                linear_extrude(height = inner_height + 1, convexity = convexity)
                    RoundedRectangle(inner_width, inner_depth, corner_radius);
        }
        
        // Add stacking lip if enabled
        if (stacking_lip > 0) {
            difference() {
                linear_extrude(height = floor_thickness + stacking_lip, convexity = convexity)
                    RoundedRectangle(outer_width, outer_depth, corner_radius);
                
                // Create inner part of lip
                translate([wall_thickness, wall_thickness, 0])
                    linear_extrude(height = floor_thickness + stacking_lip + 1, convexity = convexity)
                        RoundedRectangle(inner_width, inner_depth, corner_radius * 0.7);
            }
        }
    }
}

module SanityCheck() {
    // Basic positive checks
    assert(outer_width > 0, "outer_width must be positive");
    assert(outer_depth > 0, "outer_depth must be positive");
    assert(height > 0, "height must be positive");
    assert(wall_thickness > 0, "wall_thickness must be positive");
    assert(corner_radius > 0, "corner_radius must be positive");
    assert(floor_thickness > 0, "floor_thickness must be positive");
    assert(stacking_lip >= 0, "stacking_lip must be non-negative");
    
    // 3D printing constraints
    assert(wall_thickness >= 1.2, "wall_thickness should be at least 1.2mm for 0.4mm nozzle");
    assert(floor_thickness >= 1.2, "floor_thickness should be at least 1.2mm for 0.4mm nozzle");
    
    // Dimensional constraints
    assert(corner_radius < min(outer_width, outer_depth) / 2,
           "corner_radius too large for outer dimensions");
    assert(corner_radius < min(inner_width, inner_depth) / 2,
           "corner_radius too large for inner dimensions");
    assert(wall_thickness < min(outer_width, outer_depth) / 2,
           "wall_thickness too large for outer dimensions");
    
    // Stacking lip validation
    assert(stacking_lip <= 10, "stacking_lip should be reasonable (<= 10mm)");
    assert(stacking_lip < floor_thickness + 5, "stacking_lip should not be excessively tall");
}

///--- Preview ----------------------------------------------------
SanityCheck();
Bin();
