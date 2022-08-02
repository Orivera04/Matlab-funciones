% f4_10
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 4.10')

clear, clf,  axis([0,4,-10,10])
subplot(221)
xmax=pi;
n=5;
dx=xmax/(n-1);
x1=0:dx:xmax;
x1 = 0.5*(pi*cos((n+0.5-(1:n))*pi/n) + pi);
h=xmax/50;

x=0:h:xmax;
y=ones(size(x));
f1=zeros(size(x1));f1(floor(n/2))=1;
y = Lagran_(x1,f1,x);
plot(x,y, x1,zeros(size(x1)),'o')
ylabel('% error'), xlabel('x')
title('(a) 5 points, 0<x<pi')
axis([0,4,-10,10])

clear x
subplot(222)
xmax=pi;
n=7;
dx=xmax/(n-1);
x1=0:dx:xmax;
x1 = 0.5*(pi*cos((n+0.5-(1:n))*pi/n) + pi);

h=xmax/50;

x=0:h:xmax;
y=ones(size(x));
f1=zeros(size(x1));f1(floor(n/2))=1;
y = Lagran_(x1,f1,x);
plot(x,y, x1,zeros(size(x1)),'o')
ylabel('% error'), xlabel('x')
title('(b) 7 points, 0<x<pi')
axis([0,4,-10,10])
clear x
subplot(223)
xmax=pi;
n=11;
dx=xmax/(n-1);
x1=0:dx:xmax;
x1 = 0.5*(pi*cos((n+0.5-(1:n))*pi/n) + pi);

h=xmax/50;

x=0:h:xmax;
y=ones(size(x));
f1=zeros(size(x1));f1(floor(n/2))=1;
y = Lagran_(x1,f1,x);
plot(x,y, x1,zeros(size(x1)),'o')
ylabel('% error'), xlabel('x')
title('(c) 11 points, 0<x<pi')
axis([0,4,-10,10])
clear x
subplot(224)
xmax=pi;
n=21;
dx=xmax/(n-1);
x1=0:dx:xmax;
x1 = 0.5*(pi*cos((n+0.5-(1:n))*pi/n) + pi);

h=xmax/150;

x=0:h:xmax;
y=ones(size(x));
f1=zeros(size(x1));%f1(n/2)=1; 
 f1(3)=1;
y = Lagran_(x1,f1,x);
plot(x,y, x1,zeros(size(x1)),'o')
ylabel('% error'), xlabel('x')
title('(d) 21 points, 0<x<pi')
axis([0,4,-10,10])
