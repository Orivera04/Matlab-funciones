% L2_2 equivalent to L2_1; Figure 2.1 
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 2.1;  List 2.2')

clear,clf,hold off
x = (0:0.05:10)';
y=sin(x).*exp(-0.4*x);
plot(x,y)
xlabel('x'); ylabel('y')

