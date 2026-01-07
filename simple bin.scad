// rectangular_bin_with_rounded_corners.scad
// A parametric rectangular bin with rounded corners on both inside and outside.
// Author: Glenn Ellis
// Date: 2025-01-06

// Exposed parameters:
//   outer_width       - total outer width of the bin (mm)
//   outer_depth       - total outer depth of the bin (mm)
//   height            - total height of the bin (mm)
//   wall_thickness    - thickness of the walls (mm)
//   corner_radius     - radius of the rounded corners (mm)
//   floor_thickness   - thickness of the floor (mm)
//   convexity         - convexity parameter for preview rendering

outer_width = 120;
outer_depth = 80;
height = 50;
wall_thickness = 2;
corner_radius = 10;
floor_thickness = 2;
convexity = 10;       // Safe default for preview

// Derived dimensions
inner_width = outer_width - 2 * wall_thickness;
inner_depth = outer_depth - 2 * wall_thickness;
inner_height = height - floor_thickness;

module RoundedRectangle(width, depth, radius, center = false) {
    // Create a 2D rounded rectangle with given dimensions and corner radius
    translate(center ? [-width/2, -depth/2] : [0, 0])
        hull() {
            for (x = [0, 1], y = [0, 1])
                translate([x ? width - radius : radius,
                           y ? depth - radius : radius])
                    circle(r = radius, $fn = 32);
        }
}

module Bin() {
    difference() {
        // Outer shell with rounded corners
        linear_extrude(height = height, convexity = convexity)
            RoundedRectangle(outer_width, outer_depth, corner_radius);

        // Inner cavity with rounded corners
        translate([wall_thickness, wall_thickness, floor_thickness])
            linear_extrude(height = inner_height + 1, convexity = convexity)
                RoundedRectangle(inner_width, inner_depth, corner_radius);
    }
}

module SanityCheck() {
    assert(outer_width > 0, "outer_width must be positive");
    assert(outer_depth > 0, "outer_depth must be positive");
    assert(height > 0, "height must be positive");
    assert(wall_thickness > 0, "wall_thickness must be positive");
    assert(corner_radius > 0, "corner_radius must be positive");
    assert(floor_thickness > 0, "floor_thickness must be positive");
    assert(corner_radius < min(outer_width, outer_depth) / 2,
           "corner_radius too large for outer dimensions");
    assert(corner_radius < min(inner_width, inner_depth) / 2,
           "corner_radius too large for inner dimensions");
    assert(wall_thickness < min(outer_width, outer_depth) / 2,
           "wall_thickness too large for outer dimensions");
}

///--- Preview ----------------------------------------------------
SanityCheck();
Bin();
