% f4_15 same as L4_5 ; See Example 4.7   
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 4.15; List4_5')

clear,clf,hold off
z=0.01; a=3; b=3;
s(1) = 0;       x(1) = 1;      y(1) = 1;
s(2) = z;       x(2) = 1+z*a;  y(2) = 1;
s(3) = 1 - z;   x(3) = 4;      y(3) = 2 - z*b;
s(4) = 1;       x(4) = 4;      y(4) = 2;
c=polyfit(s,x,length(s)-1);
d=polyfit(s,y,length(s)-1);
ss=0:0.1:1;
xp = polyval(c,ss);
yp = polyval(d,ss);
plot(xp,yp)
ylabel('y')
xlabel('x')


