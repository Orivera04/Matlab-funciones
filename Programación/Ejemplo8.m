%gráfica de dos funciones Sin y Cos
amp1=10;
amp2=5;
num=100;
ciclos=2;
f1 =100; % Frecuencia de 100Hz
f2 =2*f1; %el doble
t=0:ciclos/(f1*num):ciclos/f1;
%calculo de funciones
y1=amp1*sin(2*pi*f1*t);
y2=amp2*cos(2*pi*f2*t);
%dibujar funciones
subplot(2,1,1); %divide en 2 filas y una columna la pantalla y selecciona la primera de las dos figuras
plot(t,y1,'Color','r');
grid;
title('Funcion Seno de 100Hz','Color','b');
subplot(2,1,2); %Selecciona la segunda de las dos figuras
plot(t,y2,'Color','r');
grid;
title('Funcion Coseno de 2*100Hz','Color','b');
xlabel('Tiempo en Segs.','Color','r');