%EX15_1 Plot solution of example in Chapter 15
%
%	File EX15_1.M
%
%	Matlab script file to numerically solve a second
%	order difference equation.
%
%	Companion file for "Dynamic Modeling and Control of 
%	Engineering Systems", 2nd ed.
%
%	y(k) -- output
%	u(k) -- input
%	t(k) -- time index
%

%	Created: 8/21/96
%	Author:  J.F. Gardner
%	Copyright 1997 by J.F. Gardner
%

%	Set up the initial conditions
%	
y(1) = 0.0;
y(2) = 0.25;
%
u(1) = 1.0;   %input is the unit step
u(2) = 1.0;
%
t(1) = 0;
t(2) = 1;
%
%  set up loop to solve the difference equation for the next 
%  nine time steps
%
for k = 3:11,
u(k) = 1.0;
t(k) = k-1;
%
y(k) = 0.6 * y(k-1) - 0.05 * y(k-2) + 0.25 * u(k-1) + 0.2 * u(k-2);
%
end;
%
plot(t,y,'x',t,u,'o')