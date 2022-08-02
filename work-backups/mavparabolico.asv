%Movimiento parabólico
%Introducir la velocidad inicial y el ángulo de lanzamiento.
clear;
clc;
v0=input('velocida inicial: ');
angulan=input('ángulo de lanzamiento: ');

%Definir tiempo de vuelo
t=input('intervalo de tiempo de vuelo: ');

%Ecuaciones de posición
x=v0*cos(angulan)*t;
y=v0*sin(angulan)*t-16*t.^2;
xmax=1/32*v0^2*sin(2*theta)
ymax=1/64*v0^2*sin(theta)^2
grid on;
hold on;
seg=0.4
n=numel(t);
hold on
axis([0 xmax 0 ymax]);
for i=1:n
    plot(x(i),y(i),'ro')
    pause(seg)
end