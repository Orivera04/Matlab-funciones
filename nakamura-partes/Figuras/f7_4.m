% f7_4
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 7.4')

clf;clear
x = 0:0.01:20;
y = cos(x).*cosh(x) + 1;
plot(x,y, x, zeros(size(x)),':');
xlabel('x'); ylabel('y = cos(x)*cosh(x)+1')
axis([0 20 -20 20])
