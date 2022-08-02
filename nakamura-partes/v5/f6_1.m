% f6_1 
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 6.1')

hold off
clear,clf
axis([0 15 0 2])
hold on
plot([0 0],[0 1.6])

plot([0 4],[0 0])

x= 0:0.05:4;
y=(exp(-0.5*x)+0.5);
xp=[1,2,3];
yp=exp(-0.5*xp)+0.5;
plot(x,y)
plot(xp,yp,'o')
xL=0.5:0.05:3.5;
a=(yp(2)-yp(3))/(xp(2)-xp(3));
x0=xp(2);b=yp(2);
yL=a*(xL-x0) + b;
plot(xL,yL)
%             vertical bar
for m=0:5:10
for k=1:3
plot([xp(k),xp(k)]+m,[0,yp(k)],':')
end
end
text(1.5,1.7, 'Forward')
text(1.5,1.55, 'Difference')
for m=0:5:10
text(-1+m,1.2,'f(x)')
text(3.7+m,0.05,'x')
text(1-0.2+m,-0.1, '-h')
text(2-0.1+m,-0.1, '0')
text(3-0.1+m,-0.1, 'h')
end

text(1.5+5,1.7, 'Backward')
text(1.5+5,1.55, 'Difference')
text(1.5+10,1.7, 'Central')
text(1.5+10,1.55, 'Difference')

%  B
plot([0 0]+5,[0 1.6])

plot([0 4]+5,[0 0])
plot(x+5,y)
plot(xp+5,yp,'o')
a=(yp(2)-yp(1))/(xp(2)-xp(1));
x0=xp(1);b=yp(1);
yL=a*(xL-x0) + b;
plot(xL+5,yL)

%  C
plot([0 0]+10,[0 1.6])

plot([0 4]+10,[0 0])
plot(x+10,y)
plot(xp+10,yp,'o')
a=(yp(3)-yp(1))/(xp(3)-xp(1));
x0=xp(1);b=yp(1);
yL=a*(xL-x0) + b;
plot(xL+10,yL)
axis('off')
