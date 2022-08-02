% P6_17.M Solve the equation
% y''+y = 1-t^2/pi^2 for 0 <= t ,=pi
%         0 elsewhere
% Calls ode23 and p617f.M
clear
t0=0;		   % Initial time
tf=3*pi;    % Final time 
x0t=[0 0]';
[t,x]=ode23('p617f',[t0,tf],x0t)   % This displays results
y=x(:,1);
%
length_t=length(t);
for I=1:length_t;
 if t(I) <=pi
  input(I)=1-t(I)^2/(pi^2);
 else
  input(I)=0;
 end
end
%
% Plot the analytic solution and compare
%
for I=1:length_t;
 if t(I) <= pi
  y2(I)=(1+2/(pi^2))*(1-cos(t(I)))-t(I)^2/(pi^2);
 else
  y2(I)=-(1+4/(pi^2))*cos(t(I))+(2/pi)*sin(t(I));
 end
end
clf
plot(t,y,'-',t,input,'+',t,y2,'o')
title('ODE23 solution ---  Input ++++ Analytical ooo')
xlabel('t')
ylabel('y(t)')
grid
%
% Observe the t and x output showing how
%  ode23 steps forward in time
%
% Version 5 Changed call to ode23; changed p617f.m