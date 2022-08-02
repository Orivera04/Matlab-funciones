function dibujarrecta(A,B,C,xmin,xmax)
%Dibuja la recta Ax+By+C=0
%xmin=input('Dar el valor mínimo de x para dibujar recta: ');
%xmax=input('Dar el valor máximo de x para dibujar recta: ');
x=xmin:0.1:xmax;
y=-(A*x+C)/B;
plot(x,y);
