%DESNUB	Parametric study for snubber design.
%	
%	This MATLAB script file is intended to accompany
%	"Dynamic Modeling and Control of Engineering Systems", 2nd ed,
%	by Kulakowski, Gardner and Shearer, Printice Hall.
%	
%	This file makes use of the MATLAB RK45 routine to run
%	a SIMULINK model from the command line 
%	
%	Parameter values are passed to the simulink model using the
%	variabls k2 and b.
%

%	
%	Author:  J.F. Gardner
%	Date:	26 February 1996
%	Copyright 1997 by J.F. Gardner
%
%   The performance index, maximum displacement, will be stored in
%	this matrix:
%
maxd=zeros(6,6);
% 
%	Possible values for the parameters:
%
kall=[1 10 20 30 40 50];
ball=[1 10 20 30 40 50];
%
%
for i=1:6,
	for j=1:6,
	b=ball(j);
	k2=kall(i);
	[T,Y]=rk45('chapt6',2);
	maxd(i,j)=max(Y(:,1));
	end;
end;
%
%  Plot the results
%
meshz(kall,ball,maxd);
view([40 15]);
ylabel('Stiffness (N/m)')
xlabel('Damping (Ns/m)')
zlabel('Maximum Overshoot (m)')
