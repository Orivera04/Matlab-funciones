ArmsVector=[2 4 5];
trial=1;
arm=ArmsVector(trial);
Ax=4;
Ay=5;
Bx=0;
By=arm;
BPx=-arm*sin(DR(10));
BPy=arm*cos(DR(10));
OldLength=hyp(Ax-Bx,Ay-By);
NewLength=hyp(Ax-BPx,Ay-BPy);
NormalStrain=(NewLength-OldLength)/OldLength
