% EX5_18.M  Use MATLAB ode23 to solve the system
%  y1''=-2y1+ y2
%  y2''=  y1-2y2
%   transformed into the system xdot=Ax where A is 4x4
% INPUTS: Initial time, final time, initial conditions and title
% OUTPUT: A (global variable); Plot of motion y1(t), y2(t)
% Pass A to function CLDESF
A=[0 0 1 0;0 0 0 1;-2 1 0 0;1 -2 0 0]      % System matrix
t0=input('Initial time=  ')
tf=input('Final time=  ')
x0=input('[y1(t0) y2(t0) doty1(t0) doty2(t0)] =  ')
x0t=x0';             % Transpose of initial conditions for ode23
% Calls function cldesf to define state equations.
[t,x]=ode23('cldesf',[t0,tf],x0t,[],A);  % Numerical solution of system
% y values
y1=x(:,1);           % Change to physical variables in example
y2=x(:,2);
% Plot y1 and y2, the motion of the masses
titlef=input('Title= ','s')   % Input the title 
subplot(2,1,1),plot(t,y1)     % Plot two graphs on one axis
ylabel('Displacement y1')
subplot(2,1,2),plot(t,y2)
ylabel('Displacement y2')
xlabel('Time')
title(eval('titlef'))
%
% Modify the file to allow different values of A to be input and
%  solve the system with other values of k1, m1 and k2, m2 in
%  Example 5.18
%
% Version 5 Change call to ode23

