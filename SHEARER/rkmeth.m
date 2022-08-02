%RKMETH Numerical integration using Runge-Kutta method.
%	File RKMETH.M
%	
	
%	Matlab script file to numerically integrate
%	a first order system for a specified time step
%	using the Runge-Kutte method (trapezoidal rule)
%	
%	Companion file for "Dynamic Modeling and Control of 
%	Engineering Systems", 2nd ed.
%	

%	Created: 7/11/95
%	Author:  J.F. Gardner
%	Copyright 1997 by J.F. Gardner
%
%	Set up the sample time, initial time and final times
%	
clear t x;
dt   = 1.0;
t(1) = 0.0;
tf   = 12.0;
%
%	Set the initial condition
%
x(1)=10.0;
%
%
%	Loop through the times, numerically evaluating the integral
%
for i=2:tf/dt+1,
	
	k1=-1/4*x(i-1)+1;
	xhat1=x(i-1)+k1*dt/2;
	k2=-1/4*xhat1+1;
	xhat2=x(i-1)+k2*dt/2;
	k3=-1/4*xhat2+1;
	xhat3=x(i-1)+k3*dt;
	k4=-1/4*xhat3+1;

	x(i)=x(i-1)+dt/6*(k1+2*k2+2*k3+k4);
	t(i)=t(i-1)+dt;
	er(i)=abs(x(i)-(6*exp(t(i)/4)+4));
end;
%
%	Plot the results using MATLAB's plot command
%
plot(t,x);