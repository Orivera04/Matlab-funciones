% f7_1
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 7.1')

clear,clg
x = 0:0.005:2;
y = x.*sin(x.^(-1));
y2 = 0.2*exp(-x);
plot(x,y,x,y2)
text(1.3, y(150)+0.05, 'y = x.*sin(x.^(-1))', 'FontSize', [18])
text(1.3, y2(150)+0.1, 'y = 0.2*exp(-x)', 'FontSize', [18])
xlabel('x')
ylabel('y')
%print figure7n1new.ps
