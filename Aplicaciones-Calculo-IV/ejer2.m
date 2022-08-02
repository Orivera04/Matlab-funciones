% Define los s�mbolos algebraicos a utilizar
syms x y
% Definimos la ecuaci�n de la hip�rbola
ecuacion = 1-(x^2/5^2)+(y^2/2^2)
% Aqui observamos que a=5
% La siguiente instrucci�n  grafica la hip�rbola, 
% los v�rtices est�n en (-5,0 ) y (5,0)
% graficamos en el intervalo de �20 a 20
ezplot(ecuacion,[-20,20]) 
hold on  % Este comando mantiene las graficas previas
grid on % Este commando dibuja una cuadricula en la gr�fica
% Definiendo las coordenadas de los vertices
xvertice=[-5 5 ]
yvertice=[0 0]
% Graficando los vertices
plot(xvertice,yvertice, '-ro','linewidth',0.00001)
hold off
