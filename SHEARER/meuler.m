%MEULER Numerically integrate a system of equations using Euler's Method
%	
%	File MEULER.M
%	
%	MATLAB script file to numerically integrate
%	multiple ODE's for a specified time step
%	
%	Companion file for "Dynamiocs Modeling and Control of
%	Engineering Systems", 2nd ed.
%	

%	Created: 7/30/95
%	Author: J.F. Gardner
%	Copyright 1997 by J.F. Gardner
%
%	Establish the model parameters
%
m=1;
b=.5;
k=1;
%
%	Define the input as a unit step
%
f=1.0;
%
%	Set up the integration interval, initial time and final time
%
dt=0.2;
t(1)=0.0;
tf=12.0;
%
%	Set the intitial conditions
%
x1(1)=0.0;
x2(2)=0.0;
%
%	Loop through the times, numerically evaluating the functions
%
for i=2:tf/dt+1,

	xd1=1/m*(f-b*x1(i-1)-k*x2(i-1));
	xd2=x1(i-1);
%	
	x1(i)=x1(i-1)+xd1*dt;
	x2(i)=x2(i-1)+xd2*dt;
%
	t(i)=t(i-1)+dt;
end;
%
% Plot the displacement
%
plot(t,x2);