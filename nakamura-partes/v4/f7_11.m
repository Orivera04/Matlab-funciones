% f7_11   Two ellipses; see Problem 7.10
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 7.11')

clear,clg
axis([-3.5 3.5 -4 2.5])
hold on
  dth=2*pi/50;
th=0:dth:51*dth;
x=cos(th);
y=sin(th);
plot(0.7*x-2,1.5*y)
plot(x-2,0.3*y-2.3+x)

plot(1.5*x+2,1.5*y)
plot(x+2,2*y-0.50-x)

text(-2.5,-4,'Pair A','FontSize',[18])
text(1.8,-4, 'Pair B','FontSize',[18])
axis('off')
hold off
%print twoEllipses.ps
