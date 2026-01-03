void mkPPos(){
  for(int i = 1; i<nPitch;i++){
    pPosCalc[i] = (scale*stepsMM-pPos[i-1])/frtConst+pPos[i-1];
    pPosOff[i] = EEPROM.read(i)-127;
    pPos[i] = pPosCalc[i]+pPosOff[i];
    Serial.print("pPos-");
    Serial.print(i);
    Serial.print(" ");
    Serial.println(pPos[i],0);
  }
}

void tunePPos(int pp, int stp){
  pPosOff[pp]=pPosOff[pp]+stp;
  pPos[pp]=pPosCalc[pp]+pPosOff[pp];
  go2(pPos[pp]);
  //delay(100);
  kick(0.5);
  if (pp==0) pPosOff[pp]=0;
//    Serial.print("pPos-");
//    Serial.print(pp,0);
//    Serial.print(" ");
//    Serial.println(pPos[pp],0);
  EEPROM.update(pp,pPosOff[pp]+127);
}
