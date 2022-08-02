x = linspace(0,2*pi,30);
y = sin(x);
z = cos(x);
plot(x,y)
hold on
ishold  % return 1 (True) if hold is ON
plot(x,z,'m')
hold off 
ishold  % hold is no longer ON
title 'Figure 25.8: Use of hold command'