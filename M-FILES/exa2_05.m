%EXA2_05        Example 2.5, 
%Fourier series.

t = -2: 0.05: 2;
omega = 2*pi;
x1 = cos(omega*t);
x2 = -cos(3*omega*t)/3;
x3 = cos(5*omega*t)/5;
x4 = -cos(7*omega*t)/7;
x  = 4*(x1 + x2 + x3 + x4)/pi
plot(t, x), grid
title('four-term approximation of the square wave')
xlabel('t')
