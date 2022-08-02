
function [t, y] = bvp2ode(g0, g1, g2, tspan, bc, n)

% Numerical solution y of the boundary value problem
% y'' = g0(t) + g1(t)*y + g2(t)*y', y(a) = ya, y(b) = yb,
% at n+2 evenly spaced points t in the interval tspan = [a b].
% g0, g1, and g2 are strings representing functions g0(t),
% g1(t), and g2(t), respectively. The boundary values 
% ya and yb are stored in the vector bc = [ya yb]. 

a = tspan(1);
b = tspan(2);
t = linspace(a,b,n+2);
t1 = t(2:n+1);
u = feval(g0, t1);
v = feval(g1, t1);
w = feval(g2, t1);
h = (b-a)/(n+1);
d1 = 1+.5*h*w(1:n-1);
d2 = -(2+v(1:n)*h^2);
d3 = 1-.5*h*w(2:n);
A = diag(d1,-1) + diag(d2) + diag(d3,1);
f = zeros(n,1);
f(1) = h^2*u(1) - (1+.5*h*w(1))*bc(1);
f(n) = h^2*u(n) - (1-.5*h*w(n))*bc(2);
f(2:n-1) = h^2*u(2:n-1)';
s = A\f;
y = [bc(1);s;bc(2)];
t = t';
