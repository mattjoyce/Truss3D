3dprint=1;

$fn=36;
e = 0.1;  // epsilon for fixing mesh visuals
th=2;     // thickness of frame
w=3;      // width of frame and braces
s=50;     // size of side edge
v=50;    // vertical size, tall
br=1.65;  // bolt radius
sr=15;   // suport quarter circles radius
gap_scaling=1.5;

module quartercircle(r1,thickness) {
  difference(){
    cylinder(r=r1,h=thickness);  
    translate([0,-r1,-e]) cube([r1*2,r1*2,thickness+e+e]);
    translate([-r1,0,-e]) cube([r1*2,r1*2,thickness+e+e]);
    }
  }

module truss(brace_style=2, edge_style=1) {
   difference(){  
     union(){
        difference(){
          cube([v,s,th]);
          translate([w,w,-1]) cube([v-w*2, s-w*2,th+2]);
        }
        
        if(edge_style==1){
          translate([0,s,0]) cube([v,th+(th*gap_scaling),th]);
          translate([0,s+(th*gap_scaling),th]) cube([v,th,th]);
        }
        
        if((brace_style==1) || (brace_style==3)){
          hull(){
            translate([w,w,0]) cylinder(r=w/2,h=th);
            translate([v-w,s-w,0]) cylinder(r=w/2,h=th);  
          }
        }
        if((brace_style==2) || (brace_style==3)){
          hull(){
            translate([w,s-w,0]) cylinder(r=w/2,h=th);  
            translate([v-w,w,0]) cylinder(r=w/2,h=th);
          }
        }
        translate([0,0,0]) rotate([0,0,180]) quartercircle(sr,th);  //frame
        translate([v,0,0]) rotate([0,0,270]) quartercircle(sr,th);  //frame
        translate([v,s,0]) rotate([0,0,0]) quartercircle(sr,th);    //frame
        translate([0,s,0]) rotate([0,0,90]) quartercircle(sr,th);   //frame

        translate([0,s-w,0]) rotate([0,90,90]) quartercircle(sr,w);  //joiner
        translate([v,s,0]) rotate([0,90,270]) quartercircle(sr,w);   //joiner

        translate([0,s,0]) rotate([0,90,0]) quartercircle(sr,w);  //top
        translate([v-w,s,0]) rotate([0,90,0]) quartercircle(sr,w);  //bottom
     }
        //holes
        translate([-e,s-sr/2,sr/2]) rotate([0,90,0]) cylinder(r=br,h=v+e+e); // base+top
        
        translate([sr/2,sr/2-th,-e]) rotate([0,0,0]) cylinder(r=br,h=th*5);    // non bracket edge
        translate([v-sr/2,sr/2-th,-e]) rotate([0,0,0]) cylinder(r=br,h=th*5);  // non bracket edge

        translate([sr/2,s+e,sr/2]) rotate([90,0,0]) cylinder(r=br,h=th*5);  // bracket side
        translate([v-sr/2,s+e,sr/2]) rotate([90,0,0]) cylinder(r=br,h=th*5); // bracket side


   }
}

// helpder module to rotate frame to vertical
module truss1(p1) {
  translate([0,0,s]) rotate([0,90,0]) truss(p1);
}

module frame1(p1){
translate([-th,0,0]) rotate([0,0,0]) truss1(p1);
translate([s+th,s,0]) rotate([0,0,180]) truss1(p1);
translate([s,-th,0]) rotate([0,0,90]) truss1(p1);
translate([0,s+th,0]) rotate([0,0,270]) truss1(p1);
}

module hbrace(){
      $fn=72;
      difference(){
        union(){
          translate([0,0,-th]) cube([s,s,th]);
        }
          translate([s/2,s/2,-th*3]) cylinder(r=s/2-th, h=th*4);
          //holes
          translate([sr/2,sr/2-th,-th-e]) cylinder(r=br, h=th*4);
          translate([s-sr/2+th,sr/2,-th-e]) cylinder(r=br, h=th*4);
          translate([s-sr/2,s-sr/2+th,-th-e]) cylinder(r=br, h=th*4);
          translate([sr/2-th,s-sr/2,-th-e]) cylinder(r=br, h=th*4);
      }
}

if(3dprint==1) {
  translate([s*1.2,0,0]) truss(1);
} else {  //demo
  translate([s*1.2,0,0]) truss(1);
  translate([0, 0, v/2]) frame1(1);
  translate([0, 0, -v/2]) frame1(2);
  translate([s*1.2,s*1.2,0]) truss(2);
  translate([s*1.2,s*2.4,0]) truss(3);
  translate([0,-s*1.2,0]) color("green") hbrace();
  translate([0,0,0]) color("green") hbrace();}