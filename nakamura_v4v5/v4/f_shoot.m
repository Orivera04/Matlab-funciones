% function f_shoot is called by List10_12.m.
% Copyright S. Nakamura, 1995
function  f = f_shoot(y,x,a,b)
f = [y(2); a*(y(1)-b)];
