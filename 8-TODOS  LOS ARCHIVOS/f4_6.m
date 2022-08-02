% f4_6
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 4.6')

clear, clf
subplot(221)
xmax=pi;
n=5;
dx=xmax/(n-1);
x1=0:dx:xmax;
h=xmax/50;

x=0:h:xmax;
y=ones(size(x));
for k=1:n
y = y.*( x-x1(k))/k;
end
plot(x,y, x1,zeros(size(x1)),'o')
ylabel('L(x)'), xlabel('x')
title('(a) 5 points, 0<x<pi')
clear x

subplot(222)
axis([0,4,-0.01, 0.01])
xmax=pi/2;
n=5;
dx=xmax/(n-1);
x1=0:dx:xmax;
h=xmax/50;

x=0:h:xmax;
y=ones(size(x));
for k=1:n
y = y.*( x-x1(k))/k;
end
plot(x,y*30, x1,zeros(size(x1)),'o')
ylabel('30*L(x)'),xlabel('x')
title('(b) 5 points, 0<x<pi/2')


subplot(223)
axis([0,4,-0.01, 0.01])
xmax=pi;
n=7;
dx=xmax/(n-1);
x1=0:dx:xmax;
h=xmax/50;

x=0:h:xmax;
y=ones(size(x));
for k=1:n
y = y.*( x-x1(k))/k;
end
plot(x,y*40, x1,zeros(size(x1)),'o')
ylabel('40*L(x)'),xlabel('x')
title('(c) 7 points, 0<x<pi')


subplot(224)
axis([0,4,-0.01, 0.01])
xmax=pi;
n=7;
dx=xmax/(n-1);
x1=0:dx:xmax;
m=1:n;
x1 = 0.5*(pi*cos((n+0.5-m)*pi/n)+pi);




h=xmax/50;

x=0:h:xmax;
y=ones(size(x));
for k=1:n
y = y.*( x-x1(k))/k;
end
plot(x,y*40, x1,zeros(size(x1)),'o')
ylabel('40*L(x)'),xlabel('x')
title('(d) 7 points, 0<x<pi')
text(0, 0.006,'Variably spaced abscissas')
axis([0,4,-0.01, 0.01])



