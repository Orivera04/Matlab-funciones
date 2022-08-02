%%%%% Setting up initial data and forces
clear
L=1; %meters
I=18e-6; %meters^4
E=205e9; %Pascals
x=linspace(0,L,500); %meters
DistMags=[-40 -80];
DistEnds=[0.4 1];
[DisFo, DisPl]=distload(DistMags(1), DistMags(2), DistEnds(2)-DistEnds(1));
af=[0 20 0.1 0;0 DisFo, 0.4+DisPl, 0];
MomentLoad=-2;
MomentPlace=0.2;
Supports=[0.3, 0.8];

%%%%% Solving for the support reactions
Unknowns=[[DR(90);DR(90);0] [0; max(Supports); 0] [0; 0; 0]];
Answer=threevector(af,Unknowns,MomentLoad);

%%%%% Illustrating the forces on the beam
figure(1)
showvect ([af;Answer])
title ('Forces on beam: ignoring redundant supports')
%%%%% Setting up the shear and moment diagrams
%%%%% Notice the s and m diagrams should not be summed prior to entry
%%%%% into the fixedpin.m routine. Also the shear is not integrated prior to
%%%%% entry into the routine.
s(1,:)=diagram(x,'point',af(1,2),af(1,3));
s(2,:)=diagram(x,'point',Answer(1,2),Answer(1,3));
s(3,:)=diagram(x,'point',Answer(2,2),Answer(2,3));
s(4,:)=diagram(x,'distributed',DistMags,DistEnds);
m(1,:)=diagram(x,'point',-MomentLoad,MomentPlace);

%%%%% Sending the shear and moment to the fixedpin routine. Answers broken
%%%%% up into new variables.
Redundants=fixedpin(x,s,m,Supports(1),Supports(2),E,I)
RedMoment=Redundants(1);
RedForces=Redundants(2);

%%%%% Drawing the SMSD diagrams as a check of the work so far. Not strictly
%%%%% necessary, but a good idea.  Remember, the row of matrix m which is
%%%%% the integral of shear should not be constructed before being entered
%%%%% into the redundancy routines!  These routines do this automatically.
InitShear=sum(s);
m(2,:)=diagramintegral(x,InitShear);
InitMoment=sum(m);
[InDis, InSlo]=displace(x,InitMoment,['place' 'place'],[0, max(Supports)]);
figure(2)
plotSMSD(x,InitShear, InitMoment, InSlo, InDis)
hold on
plot([0 max(Supports)],[0 0],'ko')
hold off

%%%%% Finding the support reactions for the beam knowing the forces supplied
%%%%% by the redundant supports
clear s m
af=[af;0 Redundants(2) Supports(1) 0];
Answer=threevector(af,Unknowns, MomentLoad+RedMoment);

%%%%% Illustrating the forces on the beam
figure(3)
showvect ([af;Answer])
title ('Forces on beam: including redundant support forces')
%%%%% Creating the final shear and moment diagrams
s(1,:)=diagram(x,'point',af(1,2),af(1,3)); %upward point load
s(2,:)=diagram(x,'point',af(3,2),af(3,3)); %redundant pin support
s(3,:)=diagram(x,'distributed',DistMags,DistEnds); %distributed load
s(4,:)=diagram(x,'point',Answer(1,2),Answer(1,3)); %left support
s(5,:)=diagram(x,'point',Answer(2,2),Answer(2,3)); %right support
Shear=sum(s);

m(1,:)=diagram(x,'point',-MomentLoad,MomentPlace); %Load from Moment
m(2,:)=diagram(x,'point',-RedMoment,0); % Moment from Fixed
m(3,:)=diagramintegral(x,Shear); %Integral of Shear
Moment=sum(m);

%%%%% Drawing the SMSD diagrams for the final output
[Displacement, Slope]=displace(x,Moment,['place' 'slope'],[0 0]);
figure(4)
plotSMSD(x,Shear,Moment,Slope,Displacement)
hold on
plot(Supports,[0 0],'ko')
hold off
