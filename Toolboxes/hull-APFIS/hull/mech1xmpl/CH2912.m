x=0:.001:0.16; %meters
PointAx=0.01; %meters
PointAy=0.01; %meters
Depth=0.02; %meters;
Height=diagram(x,'linear',[0.03 0.01],[0 0.16]);
Area=Height*Depth;
n(1,:)=diagram(x,'point',30,0);
n(2,:)=diagram(x,'point',-30,0.08);
Normal=sum(n);
s(1,:)=diagram(x,'point',-25,0);
s(2,:)=diagram(x,'point',25,0.16);
Shear=sum(s);
Moment=diagramintegral(x,Shear);
figure(1)
subplot(3,1,1)
plot(x,Area)
title('Area')
expandaxis; showx
subplot(3,1,2)
plot(x,Normal)
title('Normal force')
expandaxis; showx
subplot(3,1,3)
plot(x,Normal./Area)
title('Normal stress')
expandaxis, showx
Ix=Depth*Height.^3/12;
figure(2)
subplot (2,1,1)
plot(x,Shear)
title('Shear force')
expandaxis; showx
subplot(2,1,2)
plot(x,Shear.*(Height/4).*(Area/2)./(Ix*Depth))
title('Shear stress at centroid');
expandaxis; showx
figure (3)
subplot(2,1,1)
plot(x,Moment)
title('Bending Moment')
expandaxis; showx
subplot(2,1,2)
plot(x,Moment.*(Height/2)./Ix)
title('Normal stress from bending on lower edge')
expandaxis; showx
%%%
NormalStressAtA=interpolate(x,Normal./Area,PointAx)
HeightAtA=interpolate(x,Height,PointAx);
IxAtA=interpolate(x,Ix,PointAx);
ShearAtA=interpolate(x,Shear,PointAx);
QAtA=((HeightAtA/2)-(PointAy/2))*(HeightAtA*Depth);
ShearStressAtA=ShearAtA*QAtA/(IxAtA*Depth)
MomentAtA=interpolate(x,Moment,PointAx);
MomentStressAtA=MomentAtA*((HeightAtA/2)-PointAy)/IxAtA
TotalSigmaX=NormalStressAtA+MomentStressAtA;
TotalSigmaY=0;
TotalShearXY=ShearStressAtA;
StressState=[TotalSigmaX, TotalSigmaY, TotalShearXY];
figure (4)
mohrs(StressState,'plane stress')
