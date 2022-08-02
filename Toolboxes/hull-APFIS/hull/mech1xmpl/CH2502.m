fmag=[-70 40];
fplace=[2 3];
dismag=[-50 -50];
disstart=4;
dislength=2;
beamlength=11;
couplemag=130;
coupleplace=8;
disend=disstart+dislength;
cswidth=1.2;
csheight=4;
Yposition=4;
af=[[0 0]' fmag' fplace' [0 0]'];
[DisForce, DisPlace]=distload(dismag(1),dismag(2),dislength);
af(3,:)=[0 DisForce 4+DisPlace 0];
UnknownPlacement=[DR(90) 0 0;DR(90) beamlength 0;DR(180) 0 0];
Resultants=threevector(af,UnknownPlacement,couplemag);
x=0:0.01:11;
s(1,:)=diagram(x,'point',Resultants(1,2),Resultants(1,3));
s(2,:)=diagram(x,'point',fmag(1),fplace(1));
s(3,:)=diagram(x,'point',fmag(2),fplace(2));
s(4,:)=diagram(x,'distributed',dismag,[disstart disend]);
s(5,:)=diagram(x,'point',Resultants(2,2),Resultants(2,3));
Shear=sum(s);
%%%
m(1,:)=diagram(x,'point',-couplemag,coupleplace);
m(2,:)=diagramintegral(x,Shear);
Moment=sum(m);
%%%
figure(1)
plotSMD(x,Shear,Moment);

CSIx=rectangl(cswidth,csheight,'Ix');
CScentY=rectangl(cswidth,csheight,'centY');
YValue=CScentY-Yposition;
Bending=Moment*YValue/CSIx;
figure(2)
plot (x,Bending)
title ('Bending Stress')
MaxBend=max(abs(Bending))
MaxBendAt=x(find(abs(Bending)==MaxBend))
