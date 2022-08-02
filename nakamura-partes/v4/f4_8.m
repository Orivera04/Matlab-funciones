% f4_8
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 4.8')

clear, clg
subplot(231)
k=0;
x=-1:0.02:1;
y = cos(k*acos(x));
plot(x,y)
axis('square')
axis([-1 1  -1.5 1.5])
title('T0(x)')
ylabel('y'); xlabel('x')


subplot(232)
k=1;
x=-1:0.02:1;
y = cos(k*acos(x));
plot(x,y)
axis('square')
axis([-1 1 -1.5 1.5])
title('T1(x)')
ylabel('y'); xlabel('x')

subplot(233)
k=2;
x=-1:0.02:1;
y = cos(k*acos(x));
plot(x,y)
axis('square')
axis([-1 1  -1.5 1.5])
title('T2(x)')
ylabel('y'); xlabel('x')


subplot(234)
k=3;
x=-1:0.02:1;
y = cos(k*acos(x));
plot(x,y)
axis('square')
axis([-1 1 -1.5 1.5])
title('T3(x)')
ylabel('y'); xlabel('x')

subplot(235)
k=5;
x=-1:0.02:1;
y = cos(k*acos(x));
plot(x,y)
axis('square')
axis([-1 1 -1.5 1.5])
title('T5(x)')
ylabel('y'); xlabel('x')

subplot(236)
k=8;
x=-1:0.02:1;
y = cos(k*acos(x));
plot(x,y)
axis('square')
axis([-1 1 -1.5 1.5])
title('T8(x)')
ylabel('y'); xlabel('x')







