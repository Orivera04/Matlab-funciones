% EX2_15.M Compute the norm of sin(x) on the interval [0,2pi]
%  Compare symbolic and numerical result
%    (This script requires the Symbolic Math Toolbox)
% Numerical value; call function sinsq to compute (sin(x))^2
normsin1=sqrt(quad('sinsq',0,2*pi));
digits(5)                       % Define numerical format
normsin1=sym(normsin1,'d')      % Numerical value
%
% Symbolic
normsq=int('sin(x)^(2)');       % Perform symbolic integration
normsq=simple(normsq)           % Simplify the result
normsqn=int('sin(x)^2',0,2*pi)  % Definite integral
norm2=sym(normsqn^(1/2))        % Symbolic square root
normsin=double(norm2)           % Convert to a number
%
% Version 5  Use digits, sym, and double for numbers
%  See help sym/double