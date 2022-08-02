%EULMETH Numerical integration using Euler Method
%	File EULMETH.M
%	
%	Matlab script file to numerically integrate
%	a first order system for a specified time step
%	
%	Companion file for "Dynamic Modeling and Control of 
%	Engineering Systems", 2nd ed.
%

%	
%	Created: 7/6/95
%	Author:  J.F. Gardner
%	Copyright 1997 by J.F. Gardner
%
%	Set up the sample time, initial time and final times
%	
dt=1.0;
t(1)=0.0;
tf=12.0;
%
%	Set the initial condition
%
x(1)=10.0;
%
%	Loop through the times, numerically evaluating the integral
%
for i=2:tf/dt+1,
	
	xd=-1/4*x(i-1)+1;
	x(i)=x(i-1)+xd*dt;
	t(i)=t(i-1)+dt;
	er(i)=abs(x(i)-(6*exp(-t(i)/4)+4));

end;
%
%	Plot the results using MATLAB's plot command
%
plot(t,x);