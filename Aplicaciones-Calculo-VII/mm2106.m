% mm2106.m

t = linspace(0,3*pi,15);
x = sqrt(t).*cos(t);
y = sqrt(t).*sin(t);
ppxy = spline(t,[x;y]);
ti = linspace(0,3*pi); % total range, 100 points
xy=ppval(ppxy,ti);
 
plot(x,y,'d',xy(1,:),xy(2,:))
xlabel('X')
ylabel('Y')
title('Figure 21.6: Interpolated Spiral Y=f(X)')
