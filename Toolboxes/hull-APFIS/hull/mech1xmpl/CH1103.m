OldLengthBC=hyp(5,4);
NewLengthBC=(1+0.012)*OldLengthBC;
LengthAC=hyp(5,(4-9));
OldAngles=findangle(OldLengthBC,LengthAC,9);
NewAngles=findangle(NewLengthBC,LengthAC,9);
Theta=NewAngles(1)-OldAngles(1)
