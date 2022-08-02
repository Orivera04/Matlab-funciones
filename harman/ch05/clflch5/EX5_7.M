% EX5_7.M  Symbolic solution of the second order equation
%    'D2y+3*Dy+2*y=f(t)'
yeq='D2y+3*Dy+2*y=f(t)'     % Define equation for dsolve 
y=dsolve(yeq,'t');          % Solve the equation
pretty(y)                   %   and simplify the result
%
%  Try this with various forms of f(t) such as
%    f(t) = const; f(t) = exp(-.5*t), etc.
%  Here is an example 
pause
yeq='D2y+3*Dy+2*y=exp(-.5*t)'  % Define equation for dsolve 
y=dsolve(yeq,'t');             % Solve the equation
pretty(y)                      %   and simplify the result
%
%   - You could make the script very general; input f(t)
%         and the coefficients