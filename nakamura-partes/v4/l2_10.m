% L2_10: Illustration of multiple curves. 
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Plotted by List 2.10')

clear,clf,hold off
x = 0:0.05:5;
y = sin(x);
z = cos(x);
plot(x,y,x,z)

