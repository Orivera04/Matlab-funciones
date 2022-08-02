% 	INTERPOLATION OF ORIENTATIONS
GAfigure; clc; %/
% 	INTERPOLATION OF ORIENTATIONS
global RA RB u v; %/
     clf; %/
%	Problem: interpolate two orientations.
%
% 	An orientation can be characterized 
%	by a rotation from a standard pose.
%	Let the orientations be RA and RB.
%
u = e1+e2-e3; %/
v = e1+e3; %/
%% view = [-0.6  2.5  -1    1.16  -2  1.1];  %/
view = [-1 2 -1 2 -2 1]; %/
%%
%%=================================================================
% 	Initial orientation RA (applied to a bivector u^v):
%.
RA = gexp(-I3*e1*pi/2/2);
DrawBivector(RA*u/RA,RA*v/RA,'b');  %/
%% random = unit(pi*e1 + pi/exp(1)*e2 + exp(1)*e3); %/
GAtext(1.1* RA*(u+v)/RA,'" R_A"','b'); %/
axis(view); axis off; %/
GAview([30 30]); %/
GAprompt; %/
%%=================================================================
% 	Final orientation (applied to u^v):
%.
RB = gexp(-I3*e2*pi/2/2);
DrawBivector(RB*u/RB,RB*v/RB,'g');  axis(view); %/
GAtext(1.1* RB*(u+v)/RB,'" R_B"','k'); %/
GAprompt; %/
%%=================================================================
% 	Interpolation through division of total rotor:
%.
Rtot =  RB/RA %w
% which is done through incremental rotor R:
%.
n = 8;                          %/
R = gexp(sLog(Rtot)/n)
axisR = unit(GAZ(-sLog(R)/I3));   %/ 
draw(axisR,'r'); %/
%% GAtext(1.1*axisR,'R / I_3','r'); %/ %% text in fact incorrect
%%GAtext(1.1*axisR,'log(R_B / R_A) I_3^{-1}','r'); %/
title('R = exp( log( R_B/R_A ) / n)','Color','r'); %/
draw(-sLog(Rtot)/n,'r'); %/
axis(view); %/
GAprompt; %/
%%=================================================================
% 	Execute the interpolations from RA[u^v] to RB[u^v]
     Ri = RA;  %/
     for i=1:n-1  %/
	 disp(['i = ', num2str(i) ':   R' num2str(i) ' = R*R' num2str(i-1)]); %/
         Ri = R*Ri; %/
         DrawBivector(Ri*u/Ri,Ri*v/Ri); %/
         axis(view); %/
         drawnow; %/
     end %/
GAprompt; %/
title(''); %/
GAorbiter(125,10); %/
