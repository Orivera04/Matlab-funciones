% L2_5 : Figure 2.5 
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 2.5; List 2.5')

clear,clf,hold off
x = (0:0.2:10)';
y=sin(x).*exp(-0.4*x);
plot(x,y)
grid on
xlabel('x'); ylabel('y')

