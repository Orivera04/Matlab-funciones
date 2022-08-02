%% Ecuaciones Diferenciales en MATLAB(R)
% MATLAB(R) ofrece varios algoritmos num�ricos para resolver una extensa
% variedad de ecuaciones diferenciales. Esta demostraci�n ense�a la
% formulaci�n y soluci�n para tres tipos distintos de ecuaciones
% diferenciales usando MATLAB.
%
% Copyright 1984-2009 The MathWorks, Inc.
% $Revision: 2.0.0.0 $

%% El Problema del Valor Inicial
% VANDERPOLDEMO es una funci�n que define la ecuaci�n Van Der Pol.

type vanderpoldemo

%%
% La ecuaci�n se escribe como un sistema de dos funciones ODE de primer
% orden.  Estas son evaluadas para distintos valores del par�metro Mu.
% Para una integraci�n m�s r�pida, elegimos un m�todo de soluci�n basado en
% el valor del par�metro Mu.
% 
% Para Mu = 1, culaquiera de los m�todos de soluci�n ODE MATLAB pueden
% resolver la ecuaci�n Van der Pol eficientemente.  el m�todo de soluci�n
% ODE45 usado a continuaci�n es un ejemplo.  La ecuaci�n es resuelta en el
% dominio [0, 20]. 

tspan = [0, 20];
y0 = [2; 0];
Mu = 1;
ode = @(t,y) vanderpoldemo(t,y,Mu);
[t,y] = ode45(ode, tspan, y0);

% Gr�fico de la soluci�n
plot(t,y(:,1))
xlabel('t')
ylabel('Soluci�n y')
title('Ecuaci�n van der Pol, \mu = 1')

%%
% Para magnitudes m�s grandes de Mu, el problema se vuelve m�s r�gido.
% M�todos num�ricos especiales son necesarios para una integracion r�pida.
% ODE15S, ODE23S, ODE23T, y ODE23TB pueden resolver problemas r�gidos
% eficientemente.
% 
% Aqu� hay una soluci�n a la ecuaci�n van der Pol para Mu = 1000 usando
% ODE15S.

tspan = [0, 3000];
y0 = [2; 0];
Mu = 1000;
ode = @(t,y) vanderpoldemo(t,y,Mu);
[t,y] = ode15s(ode, tspan, y0);

plot(t,y(:,1))
title('Ecuaci�n van der Pol, \mu = 1000')
axis([0 3000 -3 3])
xlabel('t')
ylabel('Soluci�n y')

%% Problemas de Valor L�mite
% BVP4C resuelve problemas de valor l�mite para ecuaciones diferenciales
% ordinarias.
%
% La funci�n de ejemplo TWOODE tiene una ecuaci�n diferencial escrita como
% un sistema de dos ODE de primer orden.

type twoode

%%
% TWOBC tiene las condiciones de l�mite para TWOODE.

type twobc

%%
% Antes de utilizar BVP4C, tenemos que proporcioner una suposici�n para la
% soluci�n que queremos representar en la malla. El m�todo de soluci�n
% entonces adapta la malla dado que refina la soluci�n.
% 
% BVPINIT ensambla la suposici�n inicial en la forma que el m�todo de
% soluci�n BVP4C tendr�. Para una malla inicial de [0 1 2 3 4] y una
% suposici�n constante de y(x) = 1,  y'(x) = 0, invocamos BVPINIT de este
% modo:

solinit = bvpinit([0 1 2 3 4],[1; 0]);

%%
% Con esta suposici�n inicial, podemos resolver el problema con BVP4C.
% 
% La soluci�n sol (abajo) se evalua en los puntos xint usando DEVAL y
% graficando.

sol = bvp4c(@twoode, @twobc, solinit);

xint = linspace(0, 4, 50);
yint = deval(sol, xint);
plot(xint, yint(1,:),'b');
xlabel('x')
ylabel('Soluci�n y')
hold on

%%
% este problema particular del valor l�mite tiene exactamente dos
% soluciones.  La otra soluci�n es obtenida para una suposici�n inicial de
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
% acerca del uso de PDEPE.  Navegue a traves de esas funciones para m�s
% ejemplos.
%
% este problema de ejemplo usa funciones PDEX1PDE, PDEX1IC, y PDEX1BC.

%%
% PDEX1PDE define la ecuaci�n diferencial.

type pdex1pde

%%
% PDEX1IC establece las condiciones iniciales. 

type pdex1ic

%%
% PDEX1BC establece las condiciones l�mite.

type pdex1bc

%%
% PDEPE requiere x, la discretizaci�n espacial, y t, un vector de tiempos
% en el que se solicita una instant�nea de la soluci�n.  resolvemos este
% problema usando una malla de 20 nodos y solicitando la soluci�n a cinco
% valores de t. finalmente, extraemos y graficamos el primer componente de
% la soluci�n.

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
