include <../libs/T-Slot.scad>
use <../libs/Nema17.scad>
use <../libs/servo.scad>
use <../libs/rcube.scad>
include <../libs/gearRack.scad>
include <../libs/linearBearing.scad>
use <../libs/Getriebe.scad>

include <../parameter.scad>
use <../string/bridgeV2.scad>
include <../string/tuner.scad>
include <../mount/stand_A.scad>
include <../string/string.scad>;

module oneString(){

translate([0,0,500])rotate([0,0,0])2020Profile(1000);

translate([0,0,280]){ 
string();
bridge();
translate([0,0,0])palm();

}
}

//oneString();

module palm(){
  palmDia=28;
  palmH=9;
  moverH=palmH+5;
  moverW=10;
  moverL=160;
  translate([strPosX+palmDia/2,strPosY,0])rotate([90,0,0])cylinder(d=palmDia, h=palmH,center=true);
  
//  hull(){
//  translate([strPosX+palmDia/2,strPosY,0])rotate([90,0,0])cylinder(d=palmDia/2, h=moverH,center=true);
//  translate([strPosX+palmDia/2,strPosY,20])rotate([90,0,0])cylinder(d=palmDia/2, h=moverH,center=true);
//  }
//    hull(){
//  translate([strPosX+palmDia/2,strPosY,20])rotate([90,0,0])cylinder(d=palmDia/2, h=moverH,center=true);
//  translate([7,strPosY,20])rotate([90,0,0])cylinder(d=palmDia/2, h=moverH,center=true);
//  }
  //translate([strPosX+palmDia/2,strPosY+moverH/2,-40])rotate([90,90,0])zahnstange(1, 80, 6, moverH, 20, 0);
  //translate([strPosX+5,strPosY+palmH/2,-85])rotate([90,-90,0])zahnstange_und_rad (1.7, 180, 53, 7, 8,palmH, 20, 0, true, true);
 
  translate([-slotXY,strPosY-palmH/2,-85])rotate([-90,0,0]){
    difference(){
      union(){
        stirnrad(1.7, 55, palmH, 8, 20, 0, true);
        cylinder(d=27,h=palmH);
      }
      translate([0,0,-1])cylinder(d=8,h=palmH+2);
      translate([0,0,palmH-2])cylinder(d=21.3,h=4);
    }
      
    
  }
 
  
  translate([strPosX+moverW/2+7,strPosY,-80]){ //todo make it automatically align when changin moverL
    translate([-3, moverH/2,-palmDia/4])rotate([90,-90,0])zahnstange(1.7, moverL-palmDia/2, 4, moverH, 20, 0);
    difference(){
      hull(){
        translate([-6+moverW/2,0,moverL/2])rotate([90,0,0])cylinder(d=moverW,h=moverH,center=true);
        //translate([-6+moverW/2,0,-moverL/2])rotate([90,0,0])cylinder(d=moverW,h=moverH,center=true);  
        translate([-6,-moverH/2,-moverL/2-2])cube([moverW,moverH,1]);
      }
    //translate([-6,-moverH/2,-90])cube([14, moverH, 180]);
    //translate([-7,-(palmH/2+0.5),-90])cube([11, palmH+1, 180]);
    translate([-7,-(palmH/2+0.5),-moverL/2])cube([20, palmH+1, moverL+palmDia]);
    //translate([0,-(palmH/2+0.5),-90])cube([11, palmH+1, 180]);
    translate([-6+moverW/2,0,moverL/2])rotate([90,0,0])cylinder(d=3.3,h=moverH+2,center=true);   
    }
  }
  
  armW=16;
  pltH=3;
  axisDia=5;
  sprHlDia=3;
  sprMntL=55;
  sprMntScrwDia=5.4;
  translate([slotXY/2,0,-95]){
    t=0.3;
    difference(){
      union(){
        translate([armW,0,0])rotate([90,0,0])cylinder(d=armW,h=slotXY,center=true);
        translate([armW/2,0,0])cube([armW,slotXY,armW],center=true);
        translate([0,0,sprMntL/2])rotate([0,90,0])rcube([sprMntL,slotXY,pltH],3);
        
        translate([sprHlDia*2,0,sprMntL-sprHlDia*2])rotate([90,0,0])cylinder(d=sprHlDia*3,h=4,center=true);
        translate([sprHlDia*1,0,sprMntL-sprHlDia*2])cube([sprHlDia*2,4,sprHlDia*3],center=true);
      }
      translate([armW+pltH,0,0])cube([armW*2,slotXY/3,armW+2],center=true);
      translate([armW,0,0])rotate([90,0,0])cylinder(d=axisDia-t,h=slotXY+2,center=true);
      translate([0,0,sprMntL/2])rotate([0,90,0])cylinder(d=sprMntScrwDia,h=slotXY+2,center=true); 
      translate([sprHlDia*2,0,sprMntL-sprHlDia*2])rotate([90,0,0])cylinder(d=sprHlDia,h=6,center=true);
    }   
  
    difference(){
      hull(){
        translate([armW,0,0])rotate([90,0,0])cylinder(d=armW,h=slotXY/3-t,center=true);
        translate([armW+20,0,40])rotate([90,0,0])cylinder(d=armW,h=slotXY/3,center=true);
      }
      translate([armW,0,0])rotate([90,0,0])cylinder(d=axisDia+t,h=slotXY,center=true);
      translate([armW+20,0,40])rotate([90,0,0])cylinder(d=axisDia-t,h=slotXY,center=true);
      translate([armW+12,0,33])rotate([90,0,0])cylinder(d=3,h=slotXY,center=true);
    }
    difference(){
      translate([armW+20,strPosY,40])rotate([90,0,0])cylinder(d=palmDia,h=palmH,center=true);
      translate([armW+20,strPosY,40])rotate([90,0,0])cylinder(d=axisDia+t,h=palmH*2,center=true);
    }
      
  }
  
  
 
  color(c=[1,0.1,0.6,1]) translate([-20,9,-95])rotate([90,0,0]) servo();
  
  srvMntW=10;
  srvMntH=60;
  srvH=41;
  srvMtnScrDia=3;
  translate([0,0,-95]){
    difference(){
      translate([-slotXY/2,slotXY/2,-srvMntH/2])cube([slotXY,srvMntW,srvMntH]);
      translate([-slotXY/2-2,slotXY/2+srvMntW/2,srvMntH/2-srvMtnScrDia*1.5])rotate([0,90,0])cylinder(d=srvMtnScrDia-0.2,h=slotXY);
      translate([-slotXY/2-2,slotXY/2+srvMntW/2,-srvMntH/2+srvMtnScrDia*1.5])rotate([0,90,0])cylinder(d=srvMtnScrDia-0.2,h=slotXY);
      
      translate([0,slotXY/2+3,0])rotate([-90,0,0])cylinder(d=13,h=srvMntW);
      translate([0,slotXY/2-0.01,0])rotate([-90,0,0])cylinder(d=5.5,h=srvMntW);
    }    
  
  
  translate([-slotXY-3,0,0]){
    difference(){
      translate([-slotXY/2,slotXY/2,-srvMntH/2])cube([slotXY,srvMntW,srvMntH]);
      translate([-slotXY/2+3,slotXY/2-1,-srvH/2])cube([slotXY,srvMntW+2,srvH]);
      //translate([-4+3,slotXY,-srvH/2])cube([12,srvMntW+2,srvH*2]);
      translate([-slotXY/2-0.01,slotXY/2+srvMntW/2,srvMntH/2-srvMtnScrDia*1.5])rotate([0,90,0])cylinder(d=srvMtnScrDia+0.2,h=slotXY*2);
      translate([-slotXY/2-0.01,slotXY/2+srvMntW/2,srvMntH/2-srvMtnScrDia*1.5])rotate([0,90,0])cylinder(d1=srvMtnScrDia*2,d2=srvMtnScrDia,h=2);
      translate([-slotXY/2-0.01,slotXY/2+srvMntW/2,-srvMntH/2+srvMtnScrDia*1.5])rotate([0,90,0])cylinder(d=srvMtnScrDia+0.2,h=slotXY*2);
      translate([-slotXY/2-0.01,slotXY/2+srvMntW/2,-srvMntH/2+srvMtnScrDia*1.5])rotate([0,90,0])cylinder(d1=srvMtnScrDia*2,d2=srvMtnScrDia,h=2);
      
      translate([0,slotXY/2+3,0])rotate([-90,0,0])cylinder(d=13,h=srvMntW);
      translate([0,slotXY/2-1,0])rotate([-90,0,0])cylinder(d=5.5,h=srvMntW);
    }    
  }
}
  
}