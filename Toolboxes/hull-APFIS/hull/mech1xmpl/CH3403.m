clear all %get rid of all variables and such
clc %clear the comand window
close all %close all figures

NOP=3000; %number of data points
L=10; %meters
SupportLocation=[2 4 7]; %meters
PointLoad=[0 -25 3 0; 0 35 5 0]; %newtons
DistPlace=[7 9]; %meters
DistMag=[-20 -20]; %newtons
MomentLoad=[5]; %newton*meters
MomentPlace=[6]; %meters
E=210e9; %Pascals
I=17e-6; %Meters^4
%%%%%Don't alter below this line!%%%%%

DistribLoad=dist2y(DistMag,DistPlace);
af=[PointLoad; DistribLoad];
Redundants=sort(SupportLocation);

x=linspace(0,L,NOP);

Unknowns=[DR(90) 0 0;DR(90) L 0;0 0 0];
Reactions=threevector(af, Unknowns, sum(MomentLoad));
Left=Reactions(1,2);
Right=Reactions(2,2);

s(1,:)=diagram(x,'point',Left,0); %Support Reactions
s(2,:)=diagram(x,'point',Right,L);

PLShear=zeros(size(s)); %Point Loads
for gapli=1:rows(PointLoad);
  PLShear(gapli,:)=diagram(x,'point',PointLoad(gapli,2),PointLoad(gapli,3));
end

DLShear=zeros(size(s)); %Distributed Loads
for gapli=1:rows(DistMag)
  DLShear(gapli,:)=diagram(x,'distributed',DistMag(gapli,:),DistPlace(gapli,:));
end

TS=[s;PLShear;DLShear]; %Total Shear

for gapli=1:length(MomentLoad) 
  m(gapli,:)=diagram(x,'point',-MomentLoad(gapli),MomentPlace(gapli));
end

answer=fixedfixed(x,TS,m,Redundants,L,E,I);

RedundantMomentLeft=answer(1);
RedundantMomentRight=answer(2);

RedundantForces=0;
if length(answer)>2
  RedundantForces=answer(3:length(answer));
end

MLoad=summoment(af); %Moment from Load
MMoment=sum(MomentLoad); %Moment from Moment Load
MRFLoad=sum(RedundantForces.*Redundants'); %Moment from Redundant Forces
MRMoment=sum(answer(1:2)); %Moments from Redundant Moments


right=-(MLoad+MMoment+MRFLoad+MRMoment)/L;
left=-mag(sumforce(af),'y')-right-sum(RedundantForces);

RFShear=zeros(size(s(1,:))); %Redundant Force Shear
for gapli=1:length(RedundantForces);
  RFShear(gapli,:)=diagram(x,'point',RedundantForces(gapli),Redundants(gapli));
end

RFShear=sum(RFShear,1); %Redundant Force Shear
PLShear=sum(PLShear,1); %Point Load Shear
DLShear=sum(DLShear,1); %Distributed Load Shear

clear s
s(1,:)=diagram(x,'point',left,0);
s(2,:)=diagram(x,'point',right,L);

Shear=RFShear+PLShear+sum(s)+DLShear;
clear m
m(1,:)=diagram(x,'point',-RedundantMomentLeft,0);
m(2,:)=diagram(x,'point',-RedundantMomentRight,L);
m(3,:)=diagramintegral(x,Shear);
for gapli=4:length(MomentLoad)+3 
  m(gapli,:)=diagram(x,'point',-MomentLoad(gapli-3),MomentPlace(gapli-3));
end
Moment=sum(m);

[d sl]=displace(x,Moment,['place' 'slope'],[0 0],E,I);

figure(1)
clf
plotSMSD(x,Shear,Moment,sl,d)
hold on
plot (0,0,'rd',L,0,'rd',af(:,3),0,'g*')
if Redundants~=0
  plot (Redundants,zeros(size(Redundants)),'ko')
end
plot (DistPlace,zeros(size(DistPlace)),'y*')
plot (MomentPlace,zeros(size(MomentPlace)),'mp')
hold off
