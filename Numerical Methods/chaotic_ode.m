function yprime = chaotic_ode ( x, y )
%
%  function yprime = chaotic_ode ( x, y )
%
%  computes the derivative for the chaotic ODE.
%
a = 0.75;
b = 7.5;
%
%  For some reason, MATLAB has a nervous breakdown if I actually
%  say "cos(x)" inside the definition of yprime.
%
temp = cos ( x );

yprime = [ y(2);
        - a * y(2) - y(1)^3 + b * temp ];

