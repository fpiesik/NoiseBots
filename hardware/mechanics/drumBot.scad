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
slotWT = 3.5; //slot wall thickness 

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
    pcbH = 1.7; //pcb height
    pcbHU= 22; //pcb headroom up
    pcbHD=4; //pcb headroom down
    wTW = 1.5;
    wTD = 1.5;
    bttmH = 2;
    w = pcbW+wTW*2;
    d = pcbD+wTD;
    h = bttmH + pcbH + pcbHU + pcbHD;
    scrwM5D=5.3;
    scrwM3D=3;
    brrlCD = 9;
    midiCD= 7;
    usbW= 10;
    usbH= 6;
    $fn=16;
    
    difference(){
        rcube([w,d,h],0);
        translate([0,wTD/2,bttmH+pcbHD])rcube([pcbW,pcbD,bttmH+pcbH+pcbHU+pcbHD],0);
        translate([0,wTD/2,bttmH])rcube([pcbW-4,pcbD-4,bttmH+pcbH+pcbHU+pcbHD],0);
        
        translate([w/2,d/3,h-6])rotate([0,-90,0])cylinder(d1=5.5,d2=scrwM3D,h=wTW);
        translate([-(w/2),d/3,h-6])rotate([0,90,0])cylinder(d1=5.5,d2=scrwM3D,h=wTW);
        translate([w/2,-d/3,h-6])rotate([0,-90,0])cylinder(d1=5.5,d2=scrwM3D,h=wTW);
        translate([-(w/2),-d/3,h-6])rotate([0,90,0])cylinder(d1=5.5,d2=scrwM3D,h=wTW);
        
        translate([-pcbW/2+10.1,-d/2,bttmH+pcbHD+pcbH+6.8])rotate([-90,0,0])cylinder(d=brrlCD,h=wTD*2);
        translate([-pcbW/2+22,-d/2,bttmH+pcbHD+pcbH+6.8])rotate([-90,0,0])cylinder(d=brrlCD,h=wTD*2);
         
        translate([-pcbW/2+39.3,-d/2,bttmH+pcbHD+pcbH+3])rotate([-90,0,0])cylinder(d=midiCD,h=wTD*2);
        translate([-pcbW/2+39.3+13.8,-d/2,bttmH+pcbHD+pcbH+3])rotate([-90,0,0])cylinder(d=midiCD,h=wTD*2);
        
        translate([-pcbW/2+93.2,-d/2,bttmH+pcbHD+pcbH+13.3])rcube([usbW,wTD*2,usbH],0);
        
        translate([0,-d/2,h-6])rotate([-90,0,0])cylinder(d1=5.5,d2=scrwM3D,h=wTD);
        translate([0,d/2,(bttmH+pcbHD)/2])rotate([90,0,0])cylinder(d=scrwM3D-0.3,h=6);
    }
    
    difference(){
    translate([0,0,-slotWH])rcube([slotWH+slotWT*2,d,slotWH],0);
    translate([0,0,-slotWH])rcube([slotWH,d,slotWH],0);    
    translate([0,0,-slotWH/2])rotate([0,90,0])cylinder(d=scrwM5D, h=slotWH*2,center=true);  
    }
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