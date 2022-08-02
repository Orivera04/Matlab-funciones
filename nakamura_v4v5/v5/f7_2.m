% f7_2
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 7.2')
clear,clf
 x = 0.:0.005:2;
y = x.*sin(x.^(-1)) - 0.2*exp(-x);
x1 = [0 , 2]; y1 = [0, 0];
plot(x,y, x1, y1, ':')
text(.55, y(150)-0.3, 'y = x.*sin(x.^(-1))-0.2*exp(-x)', ...
          'FontSize', [18])
xlabel('x')
ylabel('y')
%print figure7n2new.ps
