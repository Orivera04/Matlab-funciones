%  root.m  31 August 1999
%
%  This program estimates the square root of a number.
%
w = 10.0

x = 1.0

for i = 1 : 10
  x = 0.5 * ( x + ( w / x ) );
  fprintf ( 'X = %f  X^2 = %f\n', x, x^2 )
end

