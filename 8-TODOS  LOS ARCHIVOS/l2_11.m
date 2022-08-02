% L2_11: Illustration of multiple curves.
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Plotted by List 2.11')

clear,clf,hold off
x = 0:0.05:5;
y(1,:) = sin(x);
y(2,:) = cos(x);
plot(x,y)

