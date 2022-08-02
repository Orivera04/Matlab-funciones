% List5_1.  See Example 5.1
% Copyright S. Nakamura, 1995
clear
n_points=16 ; i = 1:n_points;
h=(30-15)/(n_points-1); u = 15 + (i-1)*h;
f = 2000*u./(8.1*u.^2 + 1200);
x = trapez_v(f,h)

