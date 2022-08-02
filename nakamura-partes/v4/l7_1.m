% L7_1 same as fig7_3 : See Example 7.1.
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 7.3; List7.1')

clg;clear
x = 0:0.1:20;
y = cos(x).*cosh(x) + 1;
plot(x,y, x, zeros(size(x)));
xlabel('x'); ylabel('y = cos(x)*cosh(x)+1')

