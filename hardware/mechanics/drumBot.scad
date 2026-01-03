include <libs/T-Slot.scad>
//use <libs/Nema17.scad>
//include <libs/gearRack.scad>
//include <libs/linearBearing.scad>

include <parameter.scad>
//include <string/bridgeV2.scad>
//include <string/tuner.scad>
include <actuators/act_kickup.scad>
//include <actuators/act_Pick.scad>
//include <actuators/act_motor.scad>
//include <actuators/act_drumroll.scad>
//use <mount/stand_A.scad>


slotWH=20;
slotAH=500;
slotBH=250;
drmDia=375;
drmH=120;
slotADist=200;
slotWT = 4; //slot wall thickness 

difference(){
	//cylinder(d=drmDia, h=drmH);
	//translate([0,0,drmH-10])cylinder(d=drmDia-10, h=drmH);
}

//translate([slotADist/2,-slotAH/2,-slotWH/2])rotate([-90,0,0])rcube([slotWH,slotWH,slotAH],1);
//translate([-slotADist/2,-slotAH/2,-slotWH/2])rotate([-90,0,0])rcube([slotWH,slotWH,slotAH],1);
//translate([slotADist/2,-slotAH/2,slotWH/2+drmH])rotate([-90,0,0])rcube([slotWH,slotWH,slotAH],1);
//translate([-slotADist/2,-slotAH/2,slotWH/2+drmH])rotate([-90,0,0])rcube([slotWH,slotWH,slotAH],1);
//
//translate([slotBH/2,(drmDia/2+slotWH/2+5),-slotWH/2+drmH])rotate([0,-90,0])rcube([slotWH,slotWH,slotBH],1);
//translate([slotBH/2,-(drmDia/2+slotWH/2+5),-slotWH/2+drmH])rotate([0,-90,0])rcube([slotWH,slotWH,slotBH],1);

//translate([0,-slotAH/2,slotWH/2+drmH+10])rotate([-90,0,0])rcube([slotWH,slotWH,slotAH],1);

//translate([0,0,0])drmClmp();

//translate([0,90,145])rotate([0,90,90])kickup(0);
//translate([0,0,250])rotate([0,90,90])palm();

//put_together();
pcbMnt();

module put_together(){
	translate([0,0,0])drmClmp();
	translate([0,90,0])rotate([0,90,90])kickup(0); 
}
	
module pcbMnt(){
    pcbW =150;
    pcbD = 77;
    w = pcbW;
    d = pcbD;
    bttmH = 2;
    rcube([pcbW,pcbD,bttmH],3);
    
    translate([0,0,0]) rcube([slotWH+slotWT,d,slotWH],0);
}
module drmClmp(){
	$fa = 3;
	w=100;
	d=4;
	hB=12;
	doW=400;
	angle=30;
	ovrSnr=10;
	wt=2.5;
	scrwADia=5;
	scrwBDia=8;
	

	
	difference(){
			rcube([slotWH*2.5,slotWH,slotWH+wt*2],3);
			translate([0,slotWH,slotWH/2+wt])rotate([90,0,0])rcube([slotWH+0.1,slotWH+0.1,slotWH*2],1);
			translate([0,0,0])cylinder(d=scrwADia+0.3, h=slotWH*2);
			translate([-slotWH*0.875,0,0])cylinder(d=scrwBDia+0.1, h=slotWH*2);
			translate([slotWH*0.875,0,0])cylinder(d=scrwBDia+0.1, h=slotWH*2);
	}
	translate([0,0,-20]){
			difference(){
					rcube([slotWH*4,slotWH,hB],3);
					translate([-slotWH*0.875,0,0])cylinder(d=scrwBDia-0.4, h=slotWH*2);
					translate([slotWH*0.875,0,0])cylinder(d=scrwBDia-0.4, h=slotWH*2);
					translate([-slotWH*1.5,0,hB/2])rotate([90,0,0])cylinder(d=scrwBDia-0.4, h=slotWH*2,center=true);
					translate([slotWH*1.5,0,hB/2])rotate([90,0,0])cylinder(d=scrwBDia-0.4, h=slotWH*2,center=true);
			}
	}
	
	difference(){
			//translate([0,-d/2, 0])rcube([w,d,hA],5);
			//translate([0,0,0])rotate([0,0,-angle/2+90])rotate_extrude(angle=angle)translate([doW/2,0, 0])square([hA,hA]);
			//translate([0,0, hA])rotate([0,0,-(angle+2)/2+90])rotate_extrude(angle=angle+2)translate([doW/2-hA+20,0, 0])circle(d=hA*2);
	}
	//translate([0,0, hA])rotate([0,0,-angle/2+90])rotate_extrude(angle=angle)translate([doW/2-ovrSnr,0, 0])square([hA+ovrSnr,hB]);
}

module rcube(size,radius){
  $fn=16;
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