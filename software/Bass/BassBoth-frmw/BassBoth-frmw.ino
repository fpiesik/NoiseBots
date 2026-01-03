#include <Servo.h>
#include <MIDI.h>
#include <EEPROM.h>
MIDI_CREATE_DEFAULT_INSTANCE();

Servo servo1;
Servo servo2;


const int nPitch=18;
int root=24;
int midiChn=8;

int pPos[nPitch];
int pPosCalc[nPitch];
int pPosOff[nPitch];

int actNote;

float stepsMM=6.58;
float scale = 700;
float frtConst=17.817;
int pickPosC=95;
int pickDstM=2;
int pickDstO=7;
bool pickDir;

long actPos;


const int home1_pin = 12;  //Digital input 1
const int home2_pin = 13;  //Digital input 2

//-------choose hardware---------------------
//uncomment if Hardware V1
const int analogAux1_pin = A6;
const int analogAux2_pin = A7;
const int step1_stpPin = 3;
const int step1_dirPin = 2;
const int step1_enblPin = 4;
const int step2_stpPin = 6; 
const int step2_dirPin = 5;
const int step2_enblPin = 7;

//uncomment if hardware V2
//const int analogAux1_pin = A0;// A6 Hardware ref1
//const int analogAux2_pin = A1;// A7  "
//const int step1_stpPin = 3;
//const int step1_dirPin = 4; 
//const int step1_enblPin = 2;
//const int step2_stpPin = 6;
//const int step2_dirPin = 7;  
//const int step2_enblPin = 5; 
//--------------------------------------------

const int mosfet1_pin = 10; 
const int mosfet2_pin = 11;

const int servo1Pin = 9;
const int servo2Pin = 8;



bool step1_enbl=0;
int step1_maxSpd = 240; 
int step1_homeSpd = 2000; 
long step1_startSpd = 5000;
long step1_brkSteps = 100;
int step1_rampAmnt = 3;
bool step1_rmpDwn = 0;
bool step1_rmpUp = 0;
int step1_trgtSpd = 1500;
byte step1_dir = 0;
byte step1_move = 0;
long step1_pos=0;
long  step1_trgt;
long step1_prevTrgt;
long step1_trgtA;
long step1_trgtB;
bool step1_arrvd=1;
long step1_interval = 1000; 
unsigned long step1_prvMilli = 0; 
byte step1_homeState = 1;
byte step1_arriving=0;
long step1_prevPos;


bool step2_enbl=0;
int step2_maxSpd = 240; 
int step2_homeSpd = 1200; 
long step2_startSpd = 5000;
long step2_brkSteps = 50;
int step2_rampAmnt = 3;
bool step2_rmpDwn = 0;
bool step2_rmpUp = 0;
int step2_trgtSpd = 1500;
byte step2_dir = 0;
byte step2_move = 0;
long step2_pos=0;
long  step2_trgt;
long step2_prevTrgt;
long step2_trgtA;
long step2_trgtB;
bool step2_arrvd=1;
long step2_interval = 1000; 
unsigned long step2_prvMilli = 0; 
byte step2_homeState = 1;
byte step2_arriving=0;
long step2_prevPos;


unsigned int kick1_duration;
unsigned long kick1_prvMicro = 0;
unsigned long kick1_currMicro = 0;  

unsigned int kick2_duration;
unsigned long kick2_prvMicro = 0;
unsigned long kick2_currMicro = 0;  

int servo1_strtPos = 90;
int servo2_strtPos = 90;


byte serbyte = 0;
byte incoming = 0;





void step_home(byte stepper){
  byte home_pin;
  byte enbl_pin;
  byte dir_pin;
  byte stp_pin;
  int home_spd;

   
  if (stepper==1){
    home_pin= home1_pin;
    enbl_pin = step1_enblPin;
    dir_pin = step1_dirPin;
    stp_pin = step1_stpPin;
    home_spd = step1_homeSpd;
    step1_pos=0;
     
  }
  
   if (stepper==2){
    home_pin= home2_pin;
    enbl_pin = step2_enblPin;
    dir_pin = step2_dirPin;
    stp_pin = step2_stpPin;
    home_spd = step2_homeSpd;
    step2_pos=0;
 
  }
  
  stepDir(stepper,1); 
  
      
  while (digitalRead(home_pin)==1){
  digitalWrite(enbl_pin, LOW);
  digitalWrite(stp_pin, HIGH);
  delayMicroseconds(10);
  digitalWrite(stp_pin,LOW);
  delayMicroseconds(home_spd-10);
  }

  //digitalWrite(enblPin, HIGH);
  //digitalWrite(enbl_pin, HIGH);
  stepSndpos(stepper);
  
}





void mosfet(byte mosfet,unsigned int time){
  if(mosfet==1){
  digitalWrite (mosfet1_pin,HIGH);
  kick1_prvMicro = kick1_currMicro;  
  kick1_duration = time;
  } 
   if(mosfet==2){
  digitalWrite (mosfet2_pin,HIGH);
  kick2_prvMicro = kick2_currMicro;  
  kick2_duration = time;
  } 
}

//------------------------------------------------------------------------    
void stepEnbl(byte stepper,int state){
 byte enbl_pin;
 
 if (stepper==1) enbl_pin=step1_enblPin;
 if (stepper==2) enbl_pin=step2_enblPin;
 
 int statePin=state*-1+1;
 digitalWrite(enbl_pin, statePin);
 
 if (stepper==1)  step1_enbl=state;
 if (stepper==2)  step2_enbl=state;
 delayMicroseconds(50);
}

//------------------------------------------------------------------------
void stepDir(byte stepper,byte dir){
  byte step_dir;
  byte dir_pin;
  
  if (stepper == 1){
  step_dir=step1_dir;
  dir_pin = step1_dirPin;
  }
  if (stepper == 2){
  step_dir=step2_dir;
  dir_pin = step2_dirPin;
  }
  if(step_dir!=dir){
  digitalWrite(dir_pin, dir);
  
  
  if (stepper==1)step1_dir=dir;
  if (stepper==2)step2_dir=dir;
  delayMicroseconds(2); 
  }
}
//-------------------------------------------------------------------------
void step_setSpd(byte stepper,long spd){
  if(stepper==1){
    step1_trgtSpd= step1_maxSpd+100*step1_startSpd/(spd+100)-100*step1_startSpd/300;
    step1_rmpUp=1;
    
  }
  
  if(stepper==2){
    step2_trgtSpd= step2_maxSpd+100*step2_startSpd/(spd+100)-100*step2_startSpd/300;
    step2_rmpUp=1;
   }
   
   
}
//-------------------------------------------------------------------------
void stepSndpos(byte stepper){
  long step_pos;
  
  if(stepper==1)step_pos=step1_pos;
  if(stepper==2)step_pos=step2_pos;
  
  long pos1=step_pos/1000;
  long pos2=(step_pos-pos1*1000)/10;
  long pos3=step_pos-pos1*1000-pos2*10;
  if(stepper==1)Serial.write(255);
  if(stepper==2)Serial.write(254);
  Serial.write(pos1);
  Serial.write(pos2);
  Serial.write(pos3);
}


//-------------------------------------------------------------------------
void stepMove(byte stepper){
  
unsigned long prvMilli;
long interval;
byte stp_pin;
byte dir;
long pos;
long prev_pos;
long trgt;
int brkSteps;
byte rmpUp;
byte rmpDwn;
byte arriving;
int trgtSpd;
long startSpd;

if (stepper==1){
  prvMilli=step1_prvMilli;
  interval=step1_interval;
  stp_pin=step1_stpPin;
  dir=step1_dir;
  pos=step1_pos;
  trgt=step1_trgt;
  brkSteps=step1_brkSteps;
  rmpUp=step1_rmpUp;
  rmpDwn=step1_rmpDwn;
  arriving=step1_arriving;
  prev_pos=step1_prevPos;
  trgtSpd=step1_trgtSpd;
  startSpd=step1_startSpd;
  
}

if (stepper==2){
  prvMilli=step2_prvMilli;
  interval=step2_interval;
  stp_pin=step2_stpPin;
  dir=step2_dir;
  pos=step2_pos;
  trgt=step2_trgt;
  brkSteps=step2_brkSteps;
  rmpUp=step2_rmpUp;
  rmpDwn=step2_rmpDwn;
  arriving=step2_arriving;
  prev_pos=step2_prevPos;
  trgtSpd=step2_trgtSpd;
  startSpd=step2_startSpd;
}
  
  unsigned long currentMillis = micros();
  if(currentMillis - prvMilli >= interval) {
      
  digitalWrite(stp_pin, HIGH);
  delayMicroseconds(4);
  digitalWrite(stp_pin,LOW);
  if(dir==0)pos=pos+1;
  if(dir==1)pos=pos-1;
  if((sqrt(pow(pos - trgt,2))<brkSteps) && (sqrt(pow(pos - trgt,2))<sqrt(pow(prev_pos - trgt,2)))){
  interval = interval + 2*brkSteps / sqrt(pow(pos - trgt,2));
  //stepRmpdwn(stepper,(startSpd-trgtSpd)/brkSteps);
  arriving=1;}  
  
  prev_pos=pos;
  
  if (stepper==1){
  step1_prvMilli = currentMillis; 
  step1_pos=pos;
  step1_prevPos=prev_pos;
  step1_arriving=arriving;
  step1_interval=interval;
  }
  if (stepper==2){
  step2_prvMilli = currentMillis; 
  step2_pos=pos;
  step2_prevPos=prev_pos;
  step2_arriving=arriving;
  step2_interval=interval;
  }

  }
  
  
}
//--------------------------------------------------------------------------
void stepGo2pos(byte stepper){
  long trgt;
  long prevTrgt;
  byte trgtA;
  byte trgtB;
  byte rmpUp;
  byte rmpDwn;
  long pos;
  bool arrvd;
 
 
 if(stepper==1){
  trgt=step1_trgt;
  prevTrgt=step1_prevTrgt;
  trgtA=step1_trgtA;
  trgtB=step1_trgtB;
  rmpUp=step1_rmpUp;
  rmpDwn=step1_rmpDwn;
  pos=step1_pos;
  arrvd=step1_arrvd;
  
 }
  if(stepper==2){
  trgt=step2_trgt;
  prevTrgt=step2_prevTrgt;
  trgtA=step2_trgtA;
  trgtB=step2_trgtB;
  rmpUp=step2_rmpUp;
  rmpDwn=step2_rmpDwn;
  pos=step2_pos;
  arrvd=step2_arrvd;
 }
 
  
  rmpUp=1;
  trgt=trgtA*100+trgtB;
  if (trgt!=pos) {
  arrvd=0;
  
  if(prevTrgt>pos && trgt<pos)rmpDwn=1;
  if(prevTrgt<pos && trgt>pos)rmpDwn=1;
  
  prevTrgt=trgt;}
  
  if(stepper==1){
  step1_trgt=trgt;  
  step1_prevTrgt=prevTrgt;
  step1_rmpUp=rmpUp;
  step1_rmpDwn=rmpDwn;
  step1_arrvd=arrvd;
  step1_arriving=0;
  }
   if(stepper==2){
  step2_trgt=trgt;
  step2_prevTrgt=prevTrgt;
  step2_rmpUp=rmpUp;
  step2_rmpDwn=rmpDwn;
  step2_arrvd=arrvd;
  step2_arriving=0;
  }
  
}
//------------------------------------------------------------------------------
void stepRmpdwn(byte stepper,int amount){
  long startSpd;
  long interval;
  byte rmpDwn;
   
  if (stepper==1) {
  startSpd=step1_startSpd;
  interval=step1_interval;
  rmpDwn=step1_rmpDwn;
  }
  
  if (stepper==2) {
  startSpd=step2_startSpd;
  interval=step2_interval;
  rmpDwn=step2_rmpDwn;
  }
  
  if(startSpd>interval)interval=interval+amount;
  if(startSpd<interval)interval=interval-amount;
  if(startSpd<=interval+amount && startSpd>=interval-amount)rmpDwn=0;
  
  if (stepper==1){
  step1_rmpDwn=rmpDwn;
  step1_interval=interval;
  }
  if (stepper==2){
  step2_rmpDwn=rmpDwn;
  step2_interval=interval;
  }
  
  
  
  
  }

//--------------------------------------------------------------------------------
void stepRmpup(byte stepper){
  
  int trgtSpd;
  long interval;
  int rampAmnt;
  byte rmpUp;
  byte arriving;
   
  if (stepper==1) {
  trgtSpd=step1_trgtSpd;
  interval=step1_interval;
  rampAmnt=step1_rampAmnt;
  rmpUp=step1_rmpUp;
  arriving=step1_arriving;
  }
   if (stepper==2) {
  trgtSpd=step2_trgtSpd;
  interval=step2_interval;
  rampAmnt=step2_rampAmnt;
  rmpUp=step2_rmpUp;
  arriving=step2_arriving;
  }
  
  if(rmpUp==1 && arriving==0){
  if(trgtSpd>interval)interval=interval+rampAmnt;
  if(trgtSpd<interval)interval=interval-rampAmnt;}
  if(trgtSpd<=interval+rampAmnt && trgtSpd>=interval-rampAmnt)rmpUp=0;
  
  if (stepper==1){
  step1_rmpUp=rmpUp;
  step1_interval=interval;}
  
  if (stepper==2){
  step2_rmpUp=rmpUp;
  step2_interval=interval;}
  
}

void setServo(byte servo,byte pos){
if (servo==1 && pos!=0){
  servo1.attach(servo1Pin);
  servo1.write(pos);
 }
if (servo==2 && pos!=0){
  servo2.attach(servo2Pin);
  servo2.write(pos);
 }

 if (servo==1 && pos==0) servo1.detach();
 if (servo==2 && pos==0) servo2.detach();
 
}
