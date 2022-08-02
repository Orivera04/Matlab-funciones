% L2_12: Illustration of multiple curves.
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Plotted by List 2.12')

% Same as List2_10.m
clear,clf,hold off
x = (0:0.05:5)';
y(:,1) = sin(x);
y(:,2) = cos(x);
plot(x,y)

