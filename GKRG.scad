use<Write.scad>
total_height = 12;
diam_central_sphere = 14;
gap = 0.6;
ring_thickness = 1;
last_ring_thickness = 3;
LetteringText = " ";
NumberOfRings = 6;

// Global resolution
$fs = 0.2;  // Don't generate smaller facets than 0.5  mm
$fa = 7;    // Don't generate larger angles than 7 degrees

// Main geometry

CentralSphere();

for (i = [1 : NumberOfRings]){
	SphereN(i);
	}
	
SphereFinal(NumberOfRings + 1);

module CentralSphere() {
	difference(){
        intersection() {
            sphere(d = diam_central_sphere, center = true);
            cube([diam_central_sphere, diam_central_sphere, total_height], center = true);
        }
		cylinder(h = total_height+1, d = diam_central_sphere/2-2, center = true);
	}
}

module SphereN(N) {
    cur_sphere_d = diam_central_sphere + ring_thickness * 2 * N + gap * N;
    cur_inner_sphere_d = cur_sphere_d - ring_thickness * 2;
    
    echo("Ring:", N, ", sphere out d=", cur_sphere_d, ", in d=", cur_inner_sphere_d);
    
	rotate_extrude(convexity = 10)
		rotate([0, 0, 90])
		difference() {
			intersection(){
				circle(d = cur_sphere_d, center = true);
				square([total_height, cur_sphere_d], center = true);
				}
			translate([0, ring_thickness, 0])
				intersection() {
					circle(d = cur_sphere_d, center = true);
					square([total_height + 0.001, cur_sphere_d], center = true);
				}
			}
}

module SphereFinal(N) {
    cur_sphere_d = diam_central_sphere + ring_thickness*2*(N-1) + gap*N + last_ring_thickness*2;
    cur_inner_sphere_d = cur_sphere_d - last_ring_thickness*2; 
    
    echo("Last ring:", cur_sphere_d, "/", cur_inner_sphere_d, "N:", N);
	
	union(){
	rotate_extrude(convexity = 10)
		rotate([0, 0, 90])
		difference(){
			intersection(){
				circle(d = cur_sphere_d, center = true);
				square([total_height, cur_sphere_d], center = true);
			}
			translate([0, last_ring_thickness, 0])
				intersection(){
					circle(d = cur_sphere_d, center = true);
					square([total_height + 0.001, cur_sphere_d], center = true);
				}
			}
			writesphere(LetteringText, [0, 0, 0], cur_sphere_d / 2, t = 2.5, h = total_height - 2, rounded = true, font = "orbitron.dxf");
			union() {
				translate([-total_height/3, cur_sphere_d/2+1, 0])
					rotate([0, 90, 0])
					rotate_extrude(angle = 180, convexity = 10)
					translate([total_height/3, total_height/3, 0])
					scale([1, 2, 1])
					circle(d = total_height/3, center = true);
					
					difference(){
						translate([0, cur_sphere_d/2-last_ring_thickness, total_height/2-total_height/3/2])
						rotate([-90, 90, 0])
						linear_extrude(height = last_ring_thickness+1)
						scale([1, 2, 1])
						circle(d = total_height/3, center = true);
						sphere(d=cur_inner_sphere_d + last_ring_thickness);	
					}
					difference(){
						translate([0, cur_sphere_d/2-last_ring_thickness, -total_height/2+total_height/3/2])
						rotate([-90, 90, 0])
						linear_extrude(height = last_ring_thickness+1)
						scale([1, 2, 1])
						circle(d = total_height/3, center = true);
						sphere(d=cur_inner_sphere_d + last_ring_thickness);	
					}

			}
		}
}