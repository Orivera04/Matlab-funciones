% L2_6 : Figure 2.6 
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 2.6; List 2.6')

clear,clf,hold off
t = 0:.05:pi+.01;
y = sin(3*t).*exp(-0.3*t);
polar(t,y)
title('Polar plot')
grid

