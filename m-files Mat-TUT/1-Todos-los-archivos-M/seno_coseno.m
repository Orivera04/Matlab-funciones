% Este script dibuja sen(x) y cos(x) en la misma ventana gráfica
% tomando como dominio el intervalo de 0 a 2*pi 
 
clf  
x = 0: 2*pi/40: 2*pi;
y = sin(x);
plot(x,y,'ro')
hold on
y = cos(x);
plot(x,y,'b+')
legend('sin', 'cos')
xlabel('Eje X')
ylabel('Eje Y')
title('Gráficas de seno y coseno')
