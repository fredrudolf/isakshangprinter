include <parameters.scad>
include <lineroller_parameters.scad>
use <sweep.scad>
use <util.scad>
use <lineroller_ABC_winch.scad>

//#prev_art();
module prev_art(){
  import("../stl/lineroller_ptfe.stl");
}

base_th = 6;
flerp0=5;
flerp1=0;
l = Depth_of_lineroller_base + 2*Bearing_r + 2*Bearing_wall + flerp0 + flerp1;
track_l = l;
head_r = 3.5;
screw_r = 1.5;
screw_head_h = 2;
screw_h = 2;
tower_flerp = 18;
tower_h = Bearing_r + tower_flerp;
x_len = Depth_of_lineroller_base; // For the two "wings" with tracks for screws
y_extra = -2.0; // For the two "wings" with tracks for screws

// Module lineroller_ABC_winch() defined in lineroller_ABC_winch.scad
lineroller_ABC_winch(edge_start=35, edge_stop=90,
                     base_th = 6,
                     tower_h = tower_h,
                     tower_flerp=tower_flerp);

module slot_for_countersunk_screw(len){
  translate([-Depth_of_lineroller_base/2-flerp0, -Depth_of_lineroller_base/2, 0]){
    translate([len-Depth_of_lineroller_base/2, Depth_of_lineroller_base/2, -0.1]){
      rotate([0,0,180]){
        translate([0,0,screw_h+screw_head_h-0.01])
          linear_extrude(height=1)
          scale(1+(head_r-screw_r)/screw_r)
          translate([0,-screw_r])
          union(){
            square([track_l-screw_r, 2*screw_r]);
            translate([0,screw_r])
              circle(r=screw_r,$fn=4*10);
          }
        linear_extrude(height=screw_h+1)
          translate([0,-screw_r])
          union(){
            square([track_l-screw_r, 2*screw_r]);
            translate([0,screw_r])
              circle(r=screw_r,$fn=4*10);
          }
        translate([0,0,screw_h])
          linear_extrude(height=screw_head_h, scale=1+(head_r-screw_r)/screw_r)
          translate([0,-screw_r])
          union(){
            square([track_l-screw_r, 2*screw_r]);
            translate([0,screw_r])
              circle(r=screw_r,$fn=4*10);
          }
      }
    }
  }
}

base_mid(base_th = 6);
module base_mid(base_th, len = l){
  difference(){
    translate([-Depth_of_lineroller_base/2-flerp0, -Depth_of_lineroller_base/2, 0])
      translate([len, Depth_of_lineroller_base,0])
      rotate([0,0,180])
      right_rounded_cube2([len, Depth_of_lineroller_base, base_th], Lineroller_base_r, $fn=10*4);
    slot_for_countersunk_screw(len);
  }
}

for(k=[0,1])
  mirror([0,k,0])
  translate([l-x_len,Depth_of_lineroller_base+y_extra-0.01,0])
  base_wing(base_th = 6, x_len = x_len, y_extra = y_extra);
module base_wing(base_th, x_len, y_extra = 1){
  difference(){
    translate([-Depth_of_lineroller_base/2-flerp0, -Depth_of_lineroller_base/2, 0])
      translate([x_len/2, Depth_of_lineroller_base/2, 0])
      rotate([0,0,90])
      translate([-Depth_of_lineroller_base/2-y_extra, -x_len/2, 0])
      right_rounded_cube2([Depth_of_lineroller_base+y_extra, x_len, base_th], Lineroller_base_r, $fn=10*4);
    slot_for_countersunk_screw(x_len);
  }
}

ptfe_guide();
module ptfe_guide(){
  line_z = tower_h-Bearing_wall-Bearing_r-Bearing_small_r;
  length = 9;
  width = (Ptfe_r+2)*2;
  difference(){
    translate([-Depth_of_lineroller_base/2-flerp0,-width/2,base_th-0.1]){
      cube([length, width, line_z-base_th+0.1]);
      translate([0, width/2, line_z-base_th+0.1])
        rotate([0,90,0])
        cylinder(d=width, h=length, $fn=4*10);
    }
    translate([-Depth_of_lineroller_base/2-flerp0,-width/2,base_th-0.1])
      translate([0, width/2, line_z-base_th+0.1])
      rotate([0,90,0])
      translate([0,0,-1])
      cylinder(r=Ptfe_r, h=length+2, $fn=4*10);
  }
}
