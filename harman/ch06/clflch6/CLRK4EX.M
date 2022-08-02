% CLRK4EX.M Runge-Kutta solution of ydot=f(t,y); t=[a,b] to
%  compare clrk4 and ode45 solutions.
% INPUTS: a,b interval endpoints; m points; y0 initial value
%  Calls function clfrk4exf to define f(t,y)
a=input('Input starting point a= ')
b=input('Input end point b= ')
m=input('Number of points m= ')
y0=input('Initial value y0= ')
% Solve with fixed step size
[Trk4,Yrk4]=clrk4('clrk4exf',a,b,m,y0);   % CLRK4 solution
% ode45 solution
[Tode45,Yode45]=ode45('clrk4exf',[a,b],y0); % ODE45 solution
%
% Compare solution with clrk4 and ode45
Yexrk4=exp(Trk4);
Yexode=exp(Tode45);
erk4=abs(Yrk4-Yexrk4);
eode45=abs(Yode45-Yexode);
clf
figure(1), plot(Trk4,Yexrk4,'+',Trk4,Yrk4,'x')
hold on
plot(Tode45,Yode45)
fprintf('Strike a key to continue')
pause
hold off
% Compare error
figure(2), semilogy(Trk4,erk4,'--',Tode45,eode45,'-')
xlabel('Time in seconds')
ylabel('Log10 Error')
title('Errors comparing CLRK4 (- - -) and ODE45 (solid line)')
grid
%
% Version 5 Change call to ode45; Made two figures
