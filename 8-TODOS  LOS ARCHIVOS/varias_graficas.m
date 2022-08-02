echo on
% Define the x values.
x = 2*pi*(0:0.01:1);
% Remove old graphics, and get ready for several new ones.
close all; axes; hold on
% Run a loop to plot three sine curves.
for c = 1:3
plot(x, sin(c*x))
echo off
end
echo on
hold off
% Put a title on the figure.
title('Several Sine Curves')
pause