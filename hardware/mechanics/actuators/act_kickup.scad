include <../parameter.scad>
strSpanB=10;
bodySlotX=100;
diameter=16;

//kickup(3);
//cap();

module kickup(orient){
$fn=32;

wall=2;
coilZ=15;
bottomZ=2;
t=0.3;
ySpacing=12;

bX = slotXY;
bY=ySpacing+diameter+wall;
bZ=coilZ+bottomZ+t;

tX = bX;
tY=bY;
hub=3;
magZ=3.1;
tbottomZ=3;
tZ=hub+magZ+tbottomZ;
tDia=6.7;//6.5;
screwTdia=4.3;

conMntX=2.54;
conMntY=6.3;
conMntZ=12;
conWt=1.5;

screwMdia=3;
screwMHDia=5.5;
screwMHh=1.8;
screwAdia=4.3;

mntTh=3;
mX=bX+slotXY+mntTh+0.3;


module mnt(){
difference(){
    union(){
        translate([-mX/2+bX/2,0,-mntTh])rcube([mX,bY,mntTh],3);
        translate([-mX+bX/2+mntTh/2,0,-mntTh])rcube([mntTh,bY,bZ+mntTh+tZ],0.1);
    }
    hull(){
    translate([-bX/2-slotXY,0,slotXY/2])rotate([0,-90,0])cylinder(d=m5Dia,h=bZ,center=true);
    translate([-bX/2-slotXY,0,(bZ+tZ)-m5Dia*1.5])rotate([0,-90,0])cylinder(d=m5Dia,h=bZ,center=true);
    }
    
    translate([0,bY/2-(bY-diameter)/4,-mntTh-0.01])cylinder(d2=screwMdia,d1=screwMHDia,h=screwMHh);
		translate([0,bY/2-(bY-diameter)/4,-mntTh-1])cylinder(d=screwMdia,h=mntTh*2);

    translate([0,-(bY/2-(bY-diameter)/4),-mntTh-0.01])cylinder(d2=screwMdia,d1=screwMHDia,h=screwMHh);
    translate([0,-(bY/2-(bY-diameter)/4),-mntTh-1])cylinder(d=screwMdia,h=bZ);
    
    translate([0,0,-mntTh-1])cylinder(d=screwMdia*2+4,h=bZ);
    translate([-bX/2+conMntX/2,0,0])cube([conMntX+conWt,conMntY+conWt,conMntZ],center=true);
}
}

module base(){
$fn=16;
cableDia=2;
difference(){
    union(){
        translate([0,0,0])rcube([bX,bY,bZ],3);
        //translate([bX/2+(conMntX+conWt)/2,0,0])rcube([conMntX+conWt,conMntY+conWt*2,conMntZ],0.1);  
    }

translate([bX/2-(conMntX)/2+1,0,0])rcube([conMntX+2,conMntY,conMntZ],0.1); 
translate([0,0,0]){
translate([0,0,bottomZ])rotate([0,0,30])cylinder(d=diameter,h=100,$fn=6);
translate([0,0,0])cylinder(d=screwAdia,h=100);
translate([0,0,conMntZ-cableDia/2])rotate([0,90,0])cylinder(d=cableDia,h=100);
}
translate([0,bY/2-(bY-diameter)/4,0])cylinder(d=screwMdia-0.2,h=bZ);
translate([0,-bY/2+(bY-diameter)/4,0])cylinder(d=screwMdia-0.2,h=bZ);
}
}

module top(){
$fn=16;
difference(){
translate([0,0,0])rcube([tX,tY,tZ],3);

translate([0,0,0]){

translate([0,0,-tbottomZ])cylinder(d=tDia,h=tZ);
cylinder(d=screwTdia,h=tZ);
}
translate([0,bY/2-(bY-diameter)/4,tZ])rotate([180,0,0])cylinder(d1=screwMHDia,d2=screwMdia,h=screwMHh);
translate([0,bY/2-(bY-diameter)/4,0])cylinder(d=screwMdia+0.3,h=tZ);
translate([0,-bY/2+(bY-diameter)/4,tZ])rotate([180,0,0])cylinder(d1=screwMHDia,d2=screwMdia,h=screwMHh);
translate([0,-bY/2+(bY-diameter)/4,0])cylinder(d=screwMdia+0.3,h=tZ);
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




module coil(){
$fn=32;
magholedia=4;
wallthick=0.5;
loweridlerZ=1.8;
upperidlerZ=1.8;
rampBZ=0.2;
rampTZ=0.2;
coildia=diameter-0.5;
rampdia=coildia;
threaddepth=5;
roofZ=loweridlerZ;

difference(){
union(){
cylinder(d=magholedia+wallthick*2,h=coilZ);
translate([0,0,loweridlerZ])cylinder(d1=rampdia,d2=magholedia+wallthick*2,h=rampBZ,$fn=6);
translate([0,0,coilZ-upperidlerZ-rampTZ])cylinder(d2=rampdia/100*100,d1=magholedia+wallthick*2,h=rampTZ,$fn=6);
translate([0,0,coilZ-upperidlerZ])cylinder(d=coildia/100*100,h=upperidlerZ,,$fn=6);
//Ccube([coildia,coildia,upperidlerZ],[0,0,1]);
translate([0,0,0]){
//Ccube([coildia,coildia,loweridlerZ],[0,0,1]);
cylinder(d=coildia,h=loweridlerZ,$fn=6);

}
}

translate([0,0,-roofZ])cylinder(d=magholedia,h=coilZ);
//cylinder(d=coilthreaddia,h=coilZ+1);
}}


if(orient==0){
translate([-slotXY/2,-(slotXY/2+bX/2),0])rotate([-90,0,-90]){
rotate([0,0,180]){
base();
translate([0,0,bZ])rotate([0,0,0])top();
}
mnt();
//translate([0,tY+0,0])rotate([30,0,0])rotate([0,90,0])coil();
}
}

if(orient==1){
base();
translate([0,tY+28,tZ])rotate([180,0,0])top();
translate([0,tY+0,0])rotate([30,0,0])rotate([0,90,0])coil();
}
if(orient==2){
translate([0,0,-bZ-tZ]){
rotate([0,0,180]){
base();
translate([0,0,bZ])rotate([0,0,0])top();
}
mnt();
//translate([0,tY+0,0])rotate([30,0,0])rotate([0,90,0])coil();
}
}

if(orient==3){
translate([0,0,0]){
mnt();
//translate([0,tY+0,0])rotate([30,0,0])rotate([0,90,0])coil();
}
}
}

module cap(){
i_dia=3.8;
o_dia=13.5;
	h=4;
$fn=32;
//headZ=4;
difference(){
union(){
difference(){
sphere(d=o_dia);
translate([0,0,-o_dia/2])cube([o_dia,o_dia,o_dia],center=true);}
translate([0,0,-h])cylinder(d=o_dia,h=h);
}
translate([0,0,-h])cylinder(d=i_dia,h=h+o_dia/3);
//scale([1,1,0.5])sphere(d=i_dia);
}
}