mu=2;
yo = [2; 0];
options=odeset('Events',@vdpolevents);
tspan = linspace(0,20,100);
[t,y,te,ye]=ode45(@vdpol,tspan,yo,options,mu);
plot(t,y,te,ye(:,2),'o')
title('Figure 25.3: van der Pol Solution, |y(2)|=2')