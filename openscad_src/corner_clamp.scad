include <parameters.scad>
use <sweep.scad>
use <util.scad>

corner_clamp();
module corner_clamp(){
  wall_th = Wall_th+0.2; // A tad thicker since flex is very unwanted in this piece
  rad_b = 4;
  a = 13;
  b = Fat_beam_width+wall_th+2-a/2;
  l0 = 40;
  l1 = (Fat_beam_width+2*wall_th)*2*sqrt(3);
  d_hole_l = l0/2+2;

  difference(){
    union(){
      translate([-l1/2,-l1/sqrt(12),0])
      linear_extrude(height=wall_th)
        polygon(points = my_rounded_eqtri(l1,rad_b,5));
      for(k=[0,1])
        mirror([k,0,0])
          rotate([0,0,-30]){
            translate([-(Fat_beam_width+wall_th)+1, -l0+wall_th*sqrt(3), 0]){
              one_rounded_cube4([Fat_beam_width+wall_th-1, l0+a, Fat_beam_width+2*wall_th],
                  2, $fn=4*4);
              translate([-wall_th-1,0,0])
                rounded_cube2([2*wall_th+1, l0+a, wall_th],2,$fn=4*4);
              }
            }
      translate([0,-sqrt(2)/sqrt(5),wall_th])
        rotate([0,0,-90-45])
        inner_round_corner(1,Fat_beam_width+wall_th,120,1.0, $fn=4*8);
    }
    zip_fr_edg = 8;
    for(k=[0,1])
      mirror([k,0,0])
        rotate([0,0,-30]){
          translate([-Fat_beam_width-wall_th, -l0+4, wall_th]){
            cube([Fat_beam_width, l0+a+2, Fat_beam_width+20]);
            translate([-wall_th,0,-wall_th]){
              opening_top(exclude_left = true, wall_th=wall_th, edges=0, l=l0+2, extra_h=0);
            }

          }
          zip_l = 15+wall_th+Zip_h;
          for(k=[0,1]){
            translate([-(zip_l-Zip_h),
                    k*(-l0+wall_th*sqrt(3)+2*zip_fr_edg)-zip_fr_edg-2,
                wall_th+Min_beam_width]){
              translate([zip_l-Zip_h,0,0])
                rotate([0,90,0])
                translate([0,-Zip_w/2,0])
                cube([zip_l, Zip_w, Zip_th]);
              rotate([0,0,0])
                translate([0,-Zip_w/2,0])
                  cube([zip_l, Zip_w, Zip_h]);
            }
            translate([-Zip_h-wall_th-Min_beam_width,
                    k*(-l0+wall_th*sqrt(3)+2*zip_fr_edg)-zip_fr_edg-2,
                -1])
              translate([0,-Zip_w/2,0])
                cube([Zip_h, Zip_w, zip_l]);
          }

        }
    translate([0,l1/sqrt(3)-2*rad_b-1.3,-1]) // 1.3 chosen arbitrarily
      cylinder(d=2.5, h=wall_th+2, $fn=10);
    d_hole_r = 1.5;
    translate([0,-6,2+wall_th/2])
      rotate([-90,0,0]){
        translate([0,0,d_hole_l-0.01])
            rotate([0,0,45])
              cylinder(r1=d_hole_r+0.01, r2=0.5, h=2,$fn=40);
        rotate([0,0,45])
          cylinder(r=d_hole_r, h=d_hole_l,$fn=40);
        translate([0,0,-2+0.01])
          rotate([0,0,45])
            cylinder(r2=d_hole_r+0.01, r1=0.5, h=2,$fn=40);
      }
    fillet_r = 2.5;
    translate([0,(wall_th-fillet_r)*2,0]){
      rotate([0,0,-90-45])
        translate([-fillet_r, -fillet_r,wall_th])
          translate([fillet_r*(1-cos(15)),fillet_r*(1-cos(15)),0])
            inner_round_corner(fillet_r,30,120,2, $fn=4*8);
    }


  }

  // Channel to guide D-line and stiffen up corner
  channel_l = l1/sqrt(3)-2*rad_b-1.3-2.5/2;
  channel_r1 = 1;
  channel_r2 = 2.5;
  channel_h = 3.5;
  translate([0,l1/sqrt(3)-2*rad_b-1.3-2.5/2-0.5,wall_th])
    rotate([180,0,0])
        difference(){
            translate([-channel_r2, 0, -channel_h])
              rounded_cube2([2*channel_r2, channel_l, channel_h+0.1], 1, $fn=4*4);
            translate([-channel_r1, -1, -channel_h-0.5])
              cube([2*channel_r1, channel_l+2, channel_h+1]);
            rotate([180+45,0,0])
              translate([-channel_r2-1,0,0])
                cube(2*channel_r2+2);
        }
}
