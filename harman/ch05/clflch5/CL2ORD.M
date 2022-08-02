% CL2ORD.M - Plot solution to differential eq. system xdot=Ax:
% This M-file uses function CL2ORDF.M to define equations
%    and ode23 to solve them.
% INPUT:  Final time; Plot is from t=0 to t=tfinal
%    (System matrix is defined as A=[1 1;4 1]; x(0)=[1 1]) 
% OUTPUT: A plot of solutions x1 and x2 versus t
%
A=[1 1;4 1];          % Define system matrix to be passed to function CL2ORDF
t0=0;
tf = input('Input tfinal - function is exp(-t) + exp(3t) ')  
% Initial values x1(0) = 1, x2(0) = 1.  (Define as column vector)
x0=[1 1]';
tspan=[t0 tf];
[t,x]=ode23('CL2ORDF',tspan,x0,[],A);  % MATLAB Runge-Kutta routine
plot(t,x(:,1),'+',t,x(:,2),'-')        % Plot x1 and x2
title('Solution of dx/dt=Ax')
xlabel('time'); ylabel('x1 and x2')
legend('x1','x2')      % Annotate the graph
%
%  Suggestion: Change the script to allow matrix A to be input 
%   and experiment with different systems  
%     (i.e. change the elements of A)
%   Also, change the comments appropriately
%
% Version 5 Changed call to ode23
