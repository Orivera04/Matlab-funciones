% f2_4 same as f2_1 except with axis('square') 
% Copyright S. Nakamura, 1995
close,clear,clf,hold off
set(gcf, 'NumberTitle','off','Name', 'Figure 2.4')

x = 0:0.04:10;
y=sin(x).*exp(-0.4*x);
plot(x,y)
xlabel('x'); ylabel('y')
axis('square')
