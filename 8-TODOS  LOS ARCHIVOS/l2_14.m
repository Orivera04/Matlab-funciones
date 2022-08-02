% L2_14:Illustration of hold on/off
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Plotted by List 2.14')

clear; clf; hold off
x = 0: 0.05: 5;
y = sin(x);
plot(x,y)
hold on
z = cos(x);
plot(x,z)
hold off

