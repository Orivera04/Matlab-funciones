% f2_3 same as L2_4
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 2.3;  List 2.4')

% Plots Figure 2.3
% Copyright S. Nakamura, 1995
clear,clf,hold off
x = (0:0.4:10)';
y=sin(x).*exp(-0.4*x);
plot(x,y,'+')
xlabel('x'); ylabel('y')

