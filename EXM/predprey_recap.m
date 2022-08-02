%% Predator-Prey Chapter Recap 
% This is an executable program that illustrates the statements
% introduced in the Preditor Prey Chapter of "Experiments in MATLAB".
% You can access it with
%
%    predprey_recap
%    edit predprey_recap
%    publish predprey_recap
%
%  Related EXM programs
%
%    predprey


%% Exponential and Logistic Growth.
   close all
   figure
   k = 1
   eta = 1
   mu = 20
   t = 0:1/32:8;
   y = mu*eta*exp(k*t)./(eta*exp(k*t) + mu - eta);
   plot(t,[y; exp(t)])
   axis([0 8 0 22])
   title('Exponential and logistic growth')
   xlabel('t')
   ylabel('y')

%% ODE45 for the Logistic Model.
   figure
   k = 1
   eta = 1
   mu = 20
   ydot = @(t,y) k*(1-y/mu)*y
   ode45(ydot,[0 8],eta)

%% ODE45 for the Predator-Prey Model.
   figure
   mu = [300 200]'
   eta = [400 100]'
   signs = [1 -1]'
   pred_prey_ode = @(t,y) signs.*(1-flipud(y./mu)).*y
   period = 6.5357
   ode45(pred_prey_ode,[0 3*period],eta)

%% Our predprey gui.
   figure
   predprey
