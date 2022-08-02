%Barremos de 0 a 2pi radianes (360 grados)
theta = linspace(0,2*pi,20); 
% creamos un vector con 20 valores igual a 5
radio = linspace(5,5,20); 
polar(theta,radio, '-r*') 
