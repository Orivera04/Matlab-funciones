%Se dibujan dos poligonales diferentes en la misma ventana gráfica
clf  
x = 1:5;   
y1 = [2 11 6 9 3];
y2 = [4 5 8 6 2];
% Se crean dos vectores y1,y2 diferentes
% y se pone una leyenda
figure(2)
plot(x,y1,'r')
hold on
plot(x,y2,'b')
grid on
legend('y1','y2')
