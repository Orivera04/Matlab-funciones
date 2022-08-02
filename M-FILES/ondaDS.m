%Fourier series.
%Diente de sierra
clear;
clc;
m=input('No. de términos a usar: ')
omega = 2*pi;
syms n t;
tg= (1/n)*sin(n*omega*t);
S=char(symsum(tg,n,1,m)/pi+1/2);
ezplot(S,[-1 1]);
title(['Onda Diente de Sierra con ',num2str(m),' términos']);
hold on;
x=[-1,-1,0,0,1,1];
y=[0,1,-0,1,0,1];
plot(x,y,'r-');