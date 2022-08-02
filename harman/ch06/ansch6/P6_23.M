% P6_23.M To compute solution of y''+b*exp(at)=0 and plot y(t)
%  INPUT: Coefficients a,b; initial and final time; initial conditions	
% Calls ode23 and bes2f (a, b passed to function)
%
clear
a=input('Input exponent exp(at), a =  ')
b=input('Input coefficient b*exp(at), b =  ')
%
t0=input('Initial time for equation =  ')
tf=input('Final time=  ')
x0=input('[y(0) Dy(0)] =  ')
x0t=x0'
% Calls function bes2f several times for each t to define equations.
[t,x]=ode23('bes2f',[t0,tf],x0t,[],a,b);     
% Output is vector t and matrix x
% y values
y=x(:,1);
% dy=x(:,2);	% Derivative
%
clf
plot(t,y)
title('Solution to y''+b*exp(at)y=0')
%
% Version 5 Changed call to ode23 and removed global command; changed BES2F.M

