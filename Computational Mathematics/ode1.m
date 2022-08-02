function ode1(F,tspan,y0)
% ODE1  World's simplest ODE solver.
%   ODE1(F,[t0,tfinal],y0) uses Euler's method to solve
%      dy/dt = F(t,y)
%   with y(t0) = y0 on the interval t0 <= t <= tfinal.

t0 = tspan(1);
tfinal = tspan(end);
h = (tfinal - t0)/64;
t = t0
y = y0
while t < tfinal
   ydot = F(t,y);
   t = t + h
   y = y + h*sdot
end
