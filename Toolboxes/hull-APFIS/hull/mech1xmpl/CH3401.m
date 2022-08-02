clear all %get rid of all variables and such
clc %clear the comand window
close all %close all figures

NOP=1000; %number of data points
L=10; %meters
SupportLocation=[2 4 7 10]; %meters
PointLoad=[0 -25 3 0; 0 35 5 0]; %newtons
DistPlace=[7 9]; %meters
DistMag=[-20 -20]; %newtons
MomentLoad=[5]; %newton*meters
MomentPlace=[0]; %meters
E=210e9; %Pascals
I=17e-6; %Meters^4
%%%%%Don't alter below this line!%%%%%

DistribLoad=dist2y(DistMag,DistPlace);
af=[PointLoad; DistribLoad];
SupportLocation=sort(SupportLocation);

if length(SupportLocation)>2
  Redundants=SupportLocation(2:length(SupportLocation)-1);
else
  error ('This routine is for redundant beams, add a third support')
end

x=linspace(0,L,NOP);

First=min(SupportLocation);
Last=max(SupportLocation);

Unknowns=[DR(90) First 0;DR(90) Last 0;0 First 0];
Reactions=threevector(af, Unknowns, sum(MomentLoad));
Left=Reactions(1,2);
Right=Reactions(2,2);

s(1,:)=diagram(x,'point',Left,First);
s(2,:)=diagram(x,'point',Right,Last);

PLShear=zeros(size(s(1,:))); %Point Loads
for gapli=1:rows(PointLoad);
  PLShear(gapli,:)=diagram(x,'point',PointLoad(gapli,2),PointLoad(gapli,3));
end

DLShear=zeros(size(s(1,:))); %Distributed Loads
for gapli=1:rows(DistMag)
  DLShear(gapli,:)=diagram(x,'distributed',DistMag(gapli,:),DistPlace(gapli,:));
end

TS=[s;PLShear;DLShear]; %Total Shear

for gapli=1:length(MomentLoad) 
  m(gapli,:)=diagram(x,'point',-MomentLoad(gapli),MomentPlace(gapli));
end

RedundantForces=pinpin(x,TS,m,Redundants,[First Last],E,I);

MLoad=summoment(af,[First,0]); %Moment from Load
MMoment=sum(MomentLoad); %Moment from Moment Load
MRFLoad=sum(RedundantForces.*(Redundants'-First)); %Moment from Redundant Forces

right=-(MLoad+MMoment+MRFLoad)/(Last-First);
left=-mag(sumforce(af),'y')-right-sum(RedundantForces);

for gapli=1:length(RedundantForces);
  RFShear(gapli,:)=diagram(x,'point',RedundantForces(gapli),Redundants(gapli));
end

RFShear=sum(RFShear,1); %Redundant Force Shear
PLShear=sum(PLShear,1); %Point Load Shear
DLShear=sum(DLShear,1); %Distributed Load Shear

clear s
s(1,:)=diagram(x,'point',left,First);
s(2,:)=diagram(x,'point',right,Last);

Shear=RFShear+PLShear+sum(s)+DLShear;
clear m
m(1,:)=diagramintegral(x,Shear);
for gapli=3:length(MomentLoad)+2 
  m(gapli,:)=diagram(x,'point',-MomentLoad(gapli-2),MomentPlace(gapli-2));
end
Moment=sum(m);

[d sl]=displace(x,Moment,['place' 'place'],[First Last],E,I);

figure(1)
clf
plotSMSD(x,Shear,Moment,sl,d)
hold on

plot (SupportLocation,zeros(size(SupportLocation)),'ko')
plot (Redundants,zeros(size(Redundants)),'ro',PointLoad(:,3),0,'g*')
plot (DistPlace,zeros(size(DistPlace)),'y*')
plot (MomentPlace,zeros(size(MomentPlace)),'mp')
hold off
