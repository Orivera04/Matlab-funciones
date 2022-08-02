% Script para simualción de la ecuación diferencial escrita en ecuadif.m
%

% defina el tiempo de simulación
ti = 0;
tf = 1;

% defina las condiciones iniciales
x0 = [0.1 3]; % recuerda que en ecuadif hay "dos" ecuaciones diferenciales

% utilice ode23 para realizar la simulación

% los resultados se guardan en las variables t y x
[t,x] = ode23('ecuadif',[ti,tf],x0);

% grafique la solución obtenida
%

figure

% las dos componentes de x
subplot(211),plot(t,x)

% solamente la primera componente
subplot(212),plot(t,x(:,1))


