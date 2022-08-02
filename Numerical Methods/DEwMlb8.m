%% Differential Equations with MATLAB

%% Using MATLAB to give a numerical solution to an ODE

%%
% The ODE is 
%%
% 
% $$y' = 2y \,\mbox{--}\, 1,\ y(0)=1.$$
% 
% We use *ode45* to obtain the numeric solution.  We have to define a
% MATLAB function equal to the right side of the equation, which we can do
% with an anonymous function.

syms t
f = @(t,y) 2.*y -1

%%
% To solve and plot the approximate solution ya on the interval [0,1],
% we give the command

ode45(f, [0,1], 1)

%%
% The second argument is the interval and the last one is the value of the
% solution at the left end of the interval.

%%
% This equation is linear, so it is easy to solve symbolically.

dsolve('Dy = 2*y-1, y(0)=1','t')


%%
% We can make a table of values of the approximate and exact solutions.  We
% don't want an enormous table, so we only calculate at t=0,0.1,0.2,...,1.
% The first column in the table is t, the second the value of the 
% approximate solution, and the third the value of the exact solution.

[t,ya] = ode45(f,0:0.1:1,1);
y = 1./2+1./2.*exp(2.*t);
format long
[t,ya,y]

%%
% The approximate and exact solutions agree to 6 decimal places.  This is a
% contrast with the result we had for the same equation when we used
% Euler's method.