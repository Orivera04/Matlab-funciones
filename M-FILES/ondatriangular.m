%Fourier series.
%Onda triangular
clear;
clc;
m=input('No. de términos a usar: ')
omega = pi;
syms n t;
tg= (1/(2*n-1)^2)*cos((2*n-1)*omega*t);
S=char(pi/2-4*symsum(tg,n,1,m)/pi);
ezplot(S,[-1 1]);
title(['Onda triangular con ',num2str(m),' términos']);
hold on;
x=[-1,0,1];
y=[3,0,3];
plot(x,y,'r-');
axis([-1.5 1.5 -0.5 3.5]);
drawAxes(2, 'k');
hold off