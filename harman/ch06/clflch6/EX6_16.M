% EX6_16.M Solve Bessel's differertial equation with variable coefficients.
%   (This requires the Symbolic Math Toolbox)
y2=dsolve('x^2*D2y + x*Dy +x^2*y =0','x')
%
% Experiment with different initial conditions and plot the 
% solutions
%
% Result
% y2 =C1*besselj(0,x)+C2*bessely(0,x)
% 
% Version 5 Changed call to dsolve