// все значения размеров в мм
use<Write.scad>
total_height = 12; // общая высота
diam_central_sphere = 14; // диаметр центральной сферы. Желательно делать немного больше чем общая высота
gap = 0.6; // зазор между кольцами. Зависит от возможностей принтера
ring_thickness = 1; // толщина колец
last_ring_thickness = 3; // толщина последнего кольца
LetteringText = " "; // текст для вывода на внешний обод последнего кольца. Длина никак не контролируется, что может приводить в проблемам.
NumberOfRings = 6; // количество внутенних колец, т.е. между центральной сферой и последнего кольца

// Global resolution
$fs = 0.2;  // Глобальный параметр - размера минимального фрагмента на поверхности. Зависит от принтера, обчыно 0.2-0.5
$fa = 5;    // Глобальный параметр - размер минимального угла для фрагмента. От этого зависит "гладкость" окружностей. Обычно 3-7. Сильно влияет на скорость рендера модели.

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
