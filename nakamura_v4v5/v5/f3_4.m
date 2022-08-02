% f3_4
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 3.4')

clear, clf
axis([14,18.5,-.2,.4])
%axis('square')

hold on

x=-2:20;
ya=(2.01045-0.12065*x)/0.98775;
yb=(2.00555-0.12032*x)/0.98755;
yc=(2.01145-0.12065*x)/0.98775;
s1=[0.12065, 0.98775; 0.12032,0.98755]\[2.01045;2.00555];
%  s1= solution for A and B
plot(s1(1),s1(2),'o')
plot([s1(1),s1(1)], [-0.2,s1(2)],':')
text(s1(1)-0.2, 0.019-0.2,'x1')
s2=[0.12065, 0.98775; 0.12032,0.98755]\[2.01145;2.00555];
%  s2= solution for A' and B

plot(s2(1),s2(2),'o')
plot([s2(1),s2(1)], [-0.2,s2(2)],':')
text(s2(1)-0.2, 0.019-0.2,'x2')

yb=(s1(2) - s2(2))/(s1(1)-s2(1))*(x-s1(1)) + s1(2);
ya=(s1(2) - s2(2)+0.01)/(s1(1)-s2(1))*(x-s1(1)) + s1(2);
yc=(s1(2)+0.01 - s2(2))/(s1(1)-s2(1))*(x-s1(1)) + s1(2)+0.01;
plot(x,yb)
plot(x,ya)
plot( x,yc,'--')

%plot([-2,19],[0.3,0.3],':');text(19.4,0.2,'x')
plot([0,0],[-3,2.8],':'); text(-0.2,3,'y')



text(-1.9,6,'Infinite number ')
text(-1.9,5.3,'of solutions')
%axis('square')
%================

text(14.3, 0.25, 'B')
text(18.2, -0.15, 'B')
text(15.5, 0.11, 'A')
text(15.5,0.16, 'C')
text(14.5, 0.38,'When line A moves to the position of line C due to slight')
text(14.5, 0.35,'changes of constants, root x1 moves substantially to x2.')
xlabel('X')
ylabel('Y')
