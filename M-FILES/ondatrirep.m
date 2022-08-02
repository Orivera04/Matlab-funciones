%Fourier series.
%Onda triangular
clear;
clc;
m=input('No. de términos a usar: ')
omega = pi;
syms n t;
tg= (1/(2*n-1)^2)*cos((2*n-1)*omega*t);
S=char(pi/2-4*symsum(tg,n,1,m)/pi);
ezplot(S,[-1 1]);hold on;
title(['Onda triangular con ',num2str(m),' términos']);
ezplot(S,[1,3]);
ezplot(S,[-3,-1]);
x1=[-1,0,1];
x2=x1-2;
x3=x1+2;
x=[x2,x1,x3];
y1=[3,0,3];
y=[y1,y1,y1];
plot(x,y,'r-');
axis([-3.5 3.5 -0.5 3.5]);
title(['Onda triangular con ',num2str(m),' términos y 3 períodos']);
drawAxes(2, 'k');