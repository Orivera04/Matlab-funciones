% EX1_8.M Plot x(t) by calling function clxfunct(t)
t=[0:.01:1.5];      % Define t values
%  Call function 
x=clxfunct(t);
% Plot the results with a grid
clf          % Clear figures
plot(t,x)
grid
% End file
%
% Add labels and annotation to the plot
%
