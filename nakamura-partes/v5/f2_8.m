% f2_8 same as L2_13
% Illustration of hold on 
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 2.8; List 2.13')

clear,clf,hold off
x = 0:0.05:5;
y = sin(x);
plot(x,y);
hold on
z = cos(x);
plot(x,z,'--')
xlabel('x');ylabel('y(-) and  z(--) ');

