% EX6_13.M Solve a first-order differential equation with variable coefficients.
%
y=dsolve('Dy + cos(x)*y = sin(x)*cos(x)','x')
ysim=simple(y)             
%
% Experiment with different variable coefficients and initial conditions
%  to determine where dsolve fails
%
% Version 5 Changed call to dsolve; added simple