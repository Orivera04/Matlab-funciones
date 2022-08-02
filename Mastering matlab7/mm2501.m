tspan = [0 20]; % time span to integrate over
yo = [2; 0]; % initial conditions (must be a column)
[t,y] = ode45(@vdpol,tspan,yo);
size(t)% number of time points
size(y) % (i)th column is y(i) at t(i)
plot(t,y(:,1),t,y(:,2),'--')
xlabel('time')
title('Figure 25.1: van der Pol Solution')
 
%(mm2501.m plot)