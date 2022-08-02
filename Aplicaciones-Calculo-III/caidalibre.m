%Caída libre: Gráfica de espacio(s)contra tiempo(t)
%Nota: No es movimiento parabólico.
%Hecho por R. Briones
%Facultad de Electrotecnia y Computación 
%Agosto 2012. versión 1.0
clc;
disp('Movimiento de Caída Libre');
disp('*********************************************** ')
%Introducir datos
%Ejemplo: 
%Datos
%espacio inicial:    s0= 0
%velocidad inicial : v0= 96
%tiempo de simulación: t= 0:0.1:6
%
disp('Datos')
s0=input('espacio inicial:    s0= ');
v0=input('velocidad inicial : v0= ');
t=input('tiempo de simulación: t= ');
n=numel(t);

%Introducir las ecuaciones de velocidad v y espacio recorrido s
v=-32*t + v0;
s=-16*t.^2 + v0*t +s0;
disp('*********************************************** ')
disp('Resultados del movimiento')
disp('Tiempo para alcanzar altura máxima: ');
t_hmax=v0/32
syms r
ecua=-16*r^2 + v0*r +s0;
disp('La altura máxima es: ');
hmax=subs(ecua,r,t_hmax)
sol=solve(ecua);
disp('Tiempo de llegada al suelo')
tsuelo=max(double(sol))
%Definir el movimiento de caída libre
a=t(n);
b=ceil(hmax);
disp('La velocidad de llegada al suelo es: ');
vsuelo=-32*tsuelo + v0
disp('************************************************* ')
seg=0.2;
disp('En 5 segundos verá la simulación del movimiento');
pause(0.2);
axis([0 a 0 b])
grid on
for i=1:n
    hold on
    plot(t(i),s(i),'ro')
    pause(seg)
end
hold off
clear
