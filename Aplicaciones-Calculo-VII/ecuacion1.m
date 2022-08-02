%Programa para resolver y graficar la solucion de la ecuacion G1.
clear; 
[x,y]=ode45(@g1,[2 4], 0.5);   
 plot(x,y);