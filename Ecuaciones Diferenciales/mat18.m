%% Ecuaciones Diferenciales en MATLAB(R)
% MATLAB(R) ofrece varios algoritmos numéricos para resolver una extensa
% variedad de ecuaciones diferenciales. Esta demostración enseña la
% formulación y solución para tres tipos distintos de ecuaciones
% diferenciales usando MATLAB.
%
% Copyright 1984-2009 The MathWorks, Inc.
% $Revision: 2.0.0.0 $

%% El Problema del Valor Inicial
% VANDERPOLDEMO es una función que define la ecuación Van Der Pol.

type vanderpoldemo

%%
% La ecuación se escribe como un sistema de dos funciones ODE de primer
% orden.  Estas son evaluadas para distintos valores del parámetro Mu.
% Para una integración más rápida, elegimos un método de solución basado en
% el valor del parámetro Mu.
% 
% Para Mu = 1, culaquiera de los métodos de solución ODE MATLAB pueden
% resolver la ecuación Van der Pol eficientemente.  el método de solución
% ODE45 usado a continuación es un ejemplo.  La ecuación es resuelta en el
% dominio [0, 20]. 

tspan = [0, 20];
y0 = [2; 0];
Mu = 1;
ode = @(t,y) vanderpoldemo(t,y,Mu);
[t,y] = ode45(ode, tspan, y0);

% Gráfico de la solución
plot(t,y(:,1))
xlabel('t')
ylabel('Solución y')
title('Ecuación van der Pol, \mu = 1')

%%
% Para magnitudes más grandes de Mu, el problema se vuelve más rígido.
% Métodos numéricos especiales son necesarios para una integracion rápida.
% ODE15S, ODE23S, ODE23T, y ODE23TB pueden resolver problemas rígidos
% eficientemente.
% 
% Aquí hay una solución a la ecuación van der Pol para Mu = 1000 usando
% ODE15S.

tspan = [0, 3000];
y0 = [2; 0];
Mu = 1000;
ode = @(t,y) vanderpoldemo(t,y,Mu);
[t,y] = ode15s(ode, tspan, y0);

plot(t,y(:,1))
title('Ecuación van der Pol, \mu = 1000')
axis([0 3000 -3 3])
xlabel('t')
ylabel('Solución y')

%% Problemas de Valor Límite
% BVP4C resuelve problemas de valor límite para ecuaciones diferenciales
% ordinarias.
%
% La función de ejemplo TWOODE tiene una ecuación diferencial escrita como
% un sistema de dos ODE de primer orden.

type twoode

%%
% TWOBC tiene las condiciones de límite para TWOODE.

type twobc

%%
% Antes de utilizar BVP4C, tenemos que proporcioner una suposición para la
% solución que queremos representar en la malla. El método de solución
% entonces adapta la malla dado que refina la solución.
% 
% BVPINIT ensambla la suposición inicial en la forma que el método de
% solución BVP4C tendrá. Para una malla inicial de [0 1 2 3 4] y una
% suposición constante de y(x) = 1,  y'(x) = 0, invocamos BVPINIT de este
% modo:

solinit = bvpinit([0 1 2 3 4],[1; 0]);

%%
% Con esta suposición inicial, podemos resolver el problema con BVP4C.
% 
% La solución sol (abajo) se evalua en los puntos xint usando DEVAL y
% graficando.

sol = bvp4c(@twoode, @twobc, solinit);

xint = linspace(0, 4, 50);
yint = deval(sol, xint);
plot(xint, yint(1,:),'b');
xlabel('x')
ylabel('Solución y')
hold on

%%
% este problema particular del valor límite tiene exactamente dos
% soluciones.  La otra solución es obtenida para una suposición inicial de
% 
%     y(x) = -1, y'(x) = 0 
% 
% y graficando como antes.

solinit = bvpinit([0 1 2 3 4],[-1; 0]);
sol = bvp4c(@twoode,@twobc,solinit);

xint = linspace(0,4,50);
yint = deval(sol,xint);
plot(xint,yint(1,:),'r');
hold off

%% Ecuaciones Diferenciales Parciales 
% PDEPE resuelve ecuaciones diferenciales parciales en una variable
% espacial y temporal.
%
% Los ejemplos PDEX1, PDEX2, PDEX3, PDEX4, PDEX5 forman un mini-tutorial
% acerca del uso de PDEPE.  Navegue a traves de esas funciones para más
% ejemplos.
%
% este problema de ejemplo usa funciones PDEX1PDE, PDEX1IC, y PDEX1BC.

%%
% PDEX1PDE define la ecuación diferencial.

type pdex1pde

%%
% PDEX1IC establece las condiciones iniciales. 

type pdex1ic

%%
% PDEX1BC establece las condiciones límite.

type pdex1bc

%%
% PDEPE requiere x, la discretización espacial, y t, un vector de tiempos
% en el que se solicita una instantánea de la solución.  resolvemos este
% problema usando una malla de 20 nodos y solicitando la solución a cinco
% valores de t. finalmente, extraemos y graficamos el primer componente de
% la solución.

x = linspace(0,1,20);
t = [0 0.5 1 1.5 2];
sol = pdepe(0,@pdex1pde,@pdex1ic,@pdex1bc,x,t);
u1 = sol(:,:,1);
surf(x,t,u1);
xlabel('x');ylabel('t');zlabel('u');
hold on

u1 = sol(:,:,1);

surf(x,t,u1);
xlabel('x'); ylabel('t'); zlabel('u');


displayEndOfDemoMessage(mfilename)
