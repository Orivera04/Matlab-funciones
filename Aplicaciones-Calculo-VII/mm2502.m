yo = [2; 0];
tspan = linspace(0,20,100);
ode45(@vdpol,tspan,yo,[],10)
title('Figure 25.2: van der Pol Solution, \mu=10')