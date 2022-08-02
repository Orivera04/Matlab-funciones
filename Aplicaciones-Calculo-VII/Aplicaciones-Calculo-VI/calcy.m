%Grafica la siguiente función a trozos
% y  =  1     if   x < -1
% y  =  x^2   if   -1 <= x <= 2
% y  =  4     if   x > 2
clc
a=input('Introduzca el límite inferior del intervalo: ');
b=input('Introduzca el límite superior del intervalo: ');
%axis([a b 0 5]);
 x = a:0.1:-1;
    y = ones(size(x));
     plot(x,y)
     hold on;
 x=-1:0.1:2;
    y = x.^2;
    plot(x,y)
x=2:0.1:b;
    y = 4*ones(size(x));
    plot(x,y)
axis([a b 0 5]);
    hold off


