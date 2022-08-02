% L2_7 : Figure 2.7 
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 2.7; List 2.7')

clear,clf,hold off
t = .1:.1:3;
x = exp(t);
y = exp(t.*sinh(t));
loglog(x,y)
grid
xlabel('x');ylabel('y')

