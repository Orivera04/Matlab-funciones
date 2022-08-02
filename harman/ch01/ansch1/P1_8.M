% P1_8.M Plot the function
%  y=3*cos(7x)+5*cos(13x)
x=[0:.01:10];	% Experiment with spacing to get a good plot
y=3*cos(7*x)+5*cos(13*x);
clf	% Clear any figures
figure(1)
plot(x,y)
title('Rectangular Coordinates')
pause
% Polar coordinates
figure(2)
polar(x,y)
