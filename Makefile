# Makefile for parametric bin project

# Default parameters for a sample bin
OUTER_WIDTH = 120
OUTER_DEPTH = 80
HEIGHT = 50
WALL_THICKNESS = 2
CORNER_RADIUS = 10
FLOOR_THICKNESS = 2

# SCAD file and output
SCAD_FILE = simple bin.scad
STL_FILE = bin_$(OUTER_WIDTH)x$(OUTER_DEPTH)x$(HEIGHT).stl

# Default target
all: $(STL_FILE)

# Generate STL from SCAD with current parameters
$(STL_FILE): $(SCAD_FILE)
	openscad -o $@ \
		-D "outer_width=$(OUTER_WIDTH)" \
		-D "outer_depth=$(OUTER_DEPTH)" \
		-D "height=$(HEIGHT)" \
		-D "wall_thickness=$(WALL_THICKNESS)" \
		-D "corner_radius=$(CORNER_RADIUS)" \
		-D "floor_thickness=$(FLOOR_THICKNESS)" \
		$<

# Batch generate all predefined bins
batch: $(SCAD_FILE)
	./generate_bins.sh

# Preview the model (opens in OpenSCAD GUI)
preview: $(SCAD_FILE)
	openscad $<

# Clean generated STL files
clean:
	rm -f bin_*.stl

# Check syntax (if available)
check:
	@echo "Checking for required tools..."
	@command -v openscad >/dev/null 2>&1 || { echo >&2 "OpenSCAD is not installed"; exit 1; }
	@command -v bash >/dev/null 2>&1 || { echo >&2 "Bash is not available"; exit 1; }
	@test -f "$(SCAD_FILE)" || { echo >&2 "SCAD file not found"; exit 1; }
	@echo "All checks passed"

.PHONY: all batch preview clean check