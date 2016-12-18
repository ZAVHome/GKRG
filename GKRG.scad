// Global resolution
/*
Global parameter - the minimum size of the fragment on the surface. Depends on the 3D printer, typically 0.2-0.5
Глобальный параметр - размера минимального фрагмента на поверхности. Зависит от 3Д принтера, обычно 0.2-0.5
*/
$fs = 0.2;

/*
Global parameter - the size of the minimum angle for the fragment. On this depends the "smoothness" of the circles. Usually 3-7. Greatly affect the speed rendering model.
Глобальный параметр - размер минимального угла для фрагмента. От этого зависит "гладкость" окружностей. Обычно 3-7. Сильно влияет на скорость рендера модели.
*/
$fa = 5;

// all size in mm
// все значения размеров в мм
use<Write.scad>

/*
Total model height 
Общая высота модели
*/
total_height = 12;

/*
The diameter of the central sphere. It is advisable to do a little more than the total_height
Диаметр центральной сферы. Желательно делать немного больше чем total_height
*/
diam_central_sphere = 14;
/*
The gap between the rings. It depends on the capabilities of 3D printer
Зазор между кольцами. Зависит от возможностей 3D принтера
*/
gap = 0.6;
/*
The thickness of the rings
Толщина колец
*/
ring_thickness = 1;

/*
The thickness of the latter (outer) ring
Толщина последнего (внешнего) кольца
*/
last_ring_thickness = 3;

/*
Text to display on the outer rim of the last ring. The length is not controlled, it can lead to problems. To generate Colta without text, should contain a "space" character.
Текст для вывода на внешний обод последнего кольца. Длина никак не контролируется, что может приводить в проблемам. Для генерации колца без текста, переменная должна содержать символ "пробел".
*/
LetteringText = " ";

/*
The number of inner rings, ie, between the central sphere and the last ring.
Количество внутренних колец, т.е. между центральной сферой и последним кольцом.
*/
NumberOfRings = 6;


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
