af=[5 0 6 3; 0 -7 3 1];
Aarea=rectangl(2,1,'area');
AcentY=rectangl(2,1,'centY');
phi=atan2(1,2);
Barea=csc(phi)*Aarea;
BcentY=csc(phi)*AcentY;
centX=BcentY*cos(phi);
centY=AcentY;
xyreaction=reaction(af,[1,0.5]);
ntreaction=twovector(opp(xyreaction),[phi, phi+DR(90)]);
tangent=ntreaction(1,:);
normal=ntreaction(2,:);
NormalStress=mag(normal)/Barea
