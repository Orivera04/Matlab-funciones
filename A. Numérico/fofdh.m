% This code is for the first order finite difference algorithm.
% It is applied to Newton's law of cooling model.
clear;
t(1) = 0;                      % Initial Time
y(1) = 200.;                   % Initial Temperature
h = 15;                        % Time Step
n = 20;                        % Number of Time Steps of Length h
y_obser = 100;                 % Observed Temperature at Time h_obser
h_obser = 5;
c = ((y_obser - y(1))/h_obser)/(70 - y(1))
a = 1 - c*h
b = c*h*70
%
% Execute the FOFD Algorithm
%
for k = 1:n
    y(k+1) = a*y(k) + b;
    t(k+1) = t(k) + h;
end
plot(t,y)

