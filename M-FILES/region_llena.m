%Programa para llenado de regiones
x = linspace(0, 4, 100);
plot(x, cos(x), 'k-', x,sin(x) , 'k--', [pi/4,5*pi/4;pi/4,5*pi/4],[-1,-1;1,1], 'k');
axis([0 5 -1 1]);
xlabel('x')
ylabel('Valores de las funciones')
title('Visualización de dos curvas que se intersectan')
text(0.2,0.7,'x=pi/4');
text(4.0,-0.7,'x = 5*pi/4');
legend('cos(x) ', 'sin(x) ', 3);
xn = linspace(pi/4,5*pi/4, 50);
hold on
fill([xn, fliplr(xn)], [sin(xn), fliplr(cos(xn))], 'c')