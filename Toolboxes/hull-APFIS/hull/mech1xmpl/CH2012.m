StressStateV=[800 0 700];
StressStateW=[-240 180 -400];
[NormalV,ShearV]=stresstr(StressStateV,DR(180-60))
[NormalW,ShearW]=stresstr(StressStateW,DR(45))
