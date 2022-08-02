%Traslaciones
%Gráfica original
syms x;
f=input('Ec original: ');
subplot(1,2,1);
x=-2:0.1:2;
plot(x,y);
axis([-4 4 0 4])
%Gráfica trasladada
 x=x-1;
 y=f(x);
 subplot(1,2,2);
 plot(x,y)
axis([-4 4 0 4])

