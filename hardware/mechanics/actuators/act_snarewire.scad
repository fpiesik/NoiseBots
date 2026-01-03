include <../parameter.scad>

$fn=32;
srvWO=33;
srvWI=23;
srvD=12.5;

wt=2;

d=3;
h=slotXY+srvD+d;
w=srvWO+wt*2;


m5Dia=5;

screwMdia=3;
screwMHDia=5.5;
screwMHh=1.8;
screwMDist=28;

//mnt();
wireguide();

module wireguide(){
	difference(){
		union(){
			translate([0,0,0])rcube([slotXY,slotXY,d],0);
			translate([0,slotXY/1.2,0])rotate([0,90,0])cylinder(d=slotXY,h=slotXY,center=true);
			translate([slotXY/2-d/2,slotXY/1.2,0])rotate([0,90,0])cylinder(d=slotXY+4,h=d,center=true);
			translate([-slotXY/2+d/2,slotXY/1.2,0])rotate([0,90,0])cylinder(d=slotXY+4,h=d,center=true);

		}
		translate([0,0,0])cylinder(d=m5Dia+0.4,h=d*3,center=true);
		translate([0,0,-slotXY])rcube([slotXY+1,slotXY*2,slotXY],0);
		translate([0,0,-slotXY-9])rcube([slotXY+1,slotXY*4,slotXY],0);

	}
}

module mnt(){
difference(){
	union(){
		translate([0,h/2,0])rcube([w,h,d],0);
		translate([0,-d/2,0])rcube([w,d,slotXY+d],0);
	}
		translate([0,slotXY/2,0])cylinder(d=m5Dia+0.4,h=d*3,center=true);
		translate([0,0,d+slotXY/2])rotate([90,0,0])cylinder(d=m5Dia+0.4,h=d*3,center=true);
			
		translate([0,srvD/2+slotXY,-0.1])rcube([srvWI,srvD,d*2],0);
		translate([screwMDist/2,slotXY+srvD/2,d-screwMHh+0.01])cylinder(d1=screwMdia,d2=screwMHDia,h=screwMHh);
		translate([screwMDist/2,slotXY+srvD/2,-1])cylinder(d=screwMdia,h=d*2);
	
		translate([-screwMDist/2,slotXY+srvD/2,d-screwMHh+0.01])cylinder(d1=screwMdia,d2=screwMHDia,h=screwMHh);
		translate([-screwMDist/2,slotXY+srvD/2,-1])cylinder(d=screwMdia,h=d*2);
	}
}

module rcube(size,radius){
linear_extrude(height=size[2])
if(radius>0){
hull()
{
    // place 4 circles in the corners, with the given radius
    translate([(-size[0]/2)+(radius), (-size[1]/2)+(radius), 0])
    circle(r=radius);

    translate([(size[0]/2)-(radius), (-size[1]/2)+(radius), 0])
    circle(r=radius);

    translate([(-size[0]/2)+(radius), (size[1]/2)-(radius), 0])
    circle(r=radius);

    translate([(size[0]/2)-(radius), (size[1]/2)-(radius), 0])
    circle(r=radius);
}
}
if(radius==0){
translate([0,0,size[2]/2])cube(size,center=true);
}
}