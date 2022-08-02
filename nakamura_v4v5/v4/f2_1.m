% f2_1 same as L2_1 
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 2.1;  List 2.1 or List 2.2')

clear,clf,hold off
x = 0:0.05:10;
y=sin(x).*exp(-0.4*x);
plot(x,y)
xlabel('x'); ylabel('y')
