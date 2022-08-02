BeamLength=25;
PointLength=20.23;
AppForce=-57;
CSBase=9;
CSHeight=5;
CSWeb=2;
CSThickness=1;
YPosition=4;
[WallForce WallMoment]=reaction([0 AppForce BeamLength 0],[0,0]);
x=[0:.01:BeamLength];
s(1,:)=diagram(x,'point',WallForce(2),0);
s(2,:)=diagram(x,'point',AppForce,BeamLength);
Shear=sum(s);
m(1,:)=diagram(x,'point',-WallMoment,0); %switch sign convention
m(2,:)=diagramintegral(x,Shear);
Moment=sum(m);figure(1)
plotSMD(x,Shear,Moment);
CSIx=ibeam(CSBase,CSHeight,CSThickness,CSWeb,'I','Ix');
CSNA=ibeam(CSBase,CSHeight,CSThickness,CSWeb,'I','centY');
YValue=CSNA-YPosition;
MomentValue=interpolate(x,Moment,PointLength);
StressValue=MomentValue*YValue/CSIx
StressVector=Moment*YValue/CSIx;
figure(2)
plot(x,StressVector)
title ('Stress')
