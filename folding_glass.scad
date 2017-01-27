// 1 для формирования стакана
// 1 for generating glass
print_glass=1;

// 1 для формирования крышки
// 1 for generating cap
print_cap=1;

// Global resolution
/*
Global parameter - the minimum size of the fragment on the surface. Depends on the 3D printer, typically 0.2-0.5
Глобальный параметр - размера минимального фрагмента на поверхности. Зависит от 3Д принтера, обычно 0.2-0.5
*/
$fs = 0.3;
/*
Global parameter - the size of the minimum angle for the fragment. On this depends the "smoothness" of the circles. Usually 3-7. Greatly affect the speed rendering model.
Глобальный параметр - размер минимального угла для фрагмента. От этого зависит "гладкость" окружностей. Обычно 3-7. Сильно влияет на скорость рендера модели.
*/
$fa = 3;

// Диаметр базовой части стакана, т.е. диаметр внутренней чаши
// The diameter of the glass base, i.e. diameter of the inner the bowl
d_base_ring = 40;

// Высота элементов для формирования стакана
// The height of the elements for generating glass
h_ring = 30;

// Высота основания.
// The height of the base
h_base = 3;

// Высота самой нижней части на которую крепится база. Является самой широкой частью объекта
// The height of the bottom part on which is fastened base. It is the widest part of the object
h_bottom_part = 3;

// Толщина колец, элементов стенок стакана
// The thickness of the rings, the elements glass wall
ring_thickness = 2;

// Зазор между кольцами
// The gap between the rings
gap = 3.6;

// Разница между диаметрами нижней и верхней части кольца
// Влияет на угол наклона стенок стакана
// The difference between the diameters of the lower and upper part of the ring
// It affects the the tilt angle glass walls
diff_d1_d2 = 2;

// Количество подвижных колец формирующих стакан
// The number of movable rings forming glass
NumberOfWall= 5;

// Выступ увеличивающий верхнюю часть кольца для уплотнения при сборке
// The protrusion increases the upper part of the assembly for sealing rings
d_protrusion = 0.5;

// Толщина стенок крышки
// The thickness of the cap wall
cap_wall_thinkness = 3;

// Качество поверхности выемок и уширений
// The quality of the surface grooves and broadening
quality_ring_surf = 100;

// Толщина слоя печати
// The thickness of the print layer
layer_thickness = 0.2;


if (print_glass==1){
	
	base();
	for (i = [1 : NumberOfWall]){
		Wall(i);
	}
}

if (print_cap==1) cap();

module Wall(N){
	cur_wall_d1 = d_base_ring + ring_thickness*N + gap*N;
	translate([0,0,h_base+h_bottom_part+layer_thickness*10])
		rotate_extrude(angle = 360, $fn = quality_ring_surf)
		translate([cur_wall_d1/2,0,0])
		polygon([
			[0,0],
			[ring_thickness/2,0],
			[ring_thickness/2+diff_d1_d2,h_ring/1.15],
			[ring_thickness/2+diff_d1_d2+d_protrusion,h_ring],
			[diff_d1_d2,h_ring],
			[0,0]
			]);
	
}

module base(){
	d_base = ring_thickness*(NumberOfWall + 1) + d_base_ring + gap*(NumberOfWall + 1) + cap_wall_thinkness*2;	
	cur_wall_d1 = d_base_ring;
	cur_wall_d2 = cur_wall_d1 + diff_d1_d2;
	
	union(){
		difference(){
			union(){
				translate([0,0,h_bottom_part])
					cylinder(d=d_base, h=h_base);
				cylinder(d=d_base+cap_wall_thinkness+3, h=h_bottom_part);
			}
			// Выемка на основании стакана
			// Groove on the basis of glass
			translate([0,0,h_base+h_bottom_part-3])
				rotate_extrude(angle = 360, $fn = quality_ring_surf)
				rotate([0,0,180])
				translate([-d_base/2,-h_base/2,0])
				scale([1.5,3,1])
				circle(d=d_protrusion);
			}
		union(){
			// Уширение для соединения базовой чаши и дна
			// Broadening of the base for the connection of the cup and the bottom
			translate([0,0,h_base+h_bottom_part])
				rotate([0,180,0])
				rotate_extrude(angle = 360, $fn = quality_ring_surf)
				rotate([0,0,180])
				translate([-cur_wall_d1/2-1,0,0])
					polygon([
						[0,0],
						[cur_wall_d1/2+1,0],
						[cur_wall_d1/2+1,layer_thickness*2],
						[cur_wall_d1/6,layer_thickness*2],
						[0,h_ring/6]
					]);
			
			// Часть стакана на базе
			// Piece of glass on the basis
			translate([0,0,h_base+h_bottom_part])
				rotate_extrude(angle = 360, $fn = quality_ring_surf)
				translate([cur_wall_d1/2,0,0])
				polygon([
					[0,0],
					[ring_thickness/2,0],
					[ring_thickness/2+diff_d1_d2,h_ring/1.15],
					[ring_thickness/2+diff_d1_d2+d_protrusion,h_ring],
					[diff_d1_d2,h_ring],
					[0,0]
					]);
		}
	}
}

module cap(){
	d_base = ring_thickness*(NumberOfWall + 1) + d_base_ring + gap*(NumberOfWall + 1) + cap_wall_thinkness*2;
	
	translate([d_base/1.25,d_base/1.25,(h_base+h_ring+cap_wall_thinkness-h_bottom_part)])
	translate([0,0,h_bottom_part])
	rotate([180,0,0])
	union(){
		difference(){
			cylinder(d=d_base + cap_wall_thinkness, h=h_base+h_ring+cap_wall_thinkness);
			translate([0,0,-cap_wall_thinkness/2])
				cylinder(d=d_base+0.2, h=h_base+h_ring+cap_wall_thinkness);
		}
		translate([0,0,h_base-3])
			rotate_extrude(angle = 360, $fn = quality_ring_surf)
			rotate([0,0,180])
			translate([-d_base/2-0.15,-h_base/2,0])
			scale([1.5,3,1])
			circle(d=d_protrusion);
	}
}