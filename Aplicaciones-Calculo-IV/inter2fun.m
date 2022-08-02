%Programa para encontrar las intersecciones de dos funciones

%Introducir las funciones y sus dominios
clc;
syms x;
f=input('La función f es f(x)= ');
g=input('La función g es g(x)= ');
dom= input('El dominio de ambas funciones es [a,b]= ');

%Encontrar los interceptos, si los hay, de dichas funciones y 
disp('soluciones de f(x)=g(x):')
disp('x=')
soluciones = solve(f-g);
disp(double(soluciones));
n=numel(soluciones);
soluciones_reales=soluciones(imag(soluciones)==0);
disp('soluciones reales')
disp('x=');
disp(double(soluciones_reales));

m=numel(soluciones_reales);
%Graficar f,g y las intersecciones
if n==0 || m==0
    disp('No hay intersecciones')
    hold on;
    ezplot(f);
    ezplot(g);
    hold off;
    break
else  
    abscisas=double(soluciones_reales);
    ordenadas=subs(f,x,abscisas);
    intersecciones=[abscisas,ordenadas];
    disp('intersecciones de las gráficas');
    fprintf('[x,y]=');
    disp('  ');
    disp(intersecciones)
    hold on;
    ezplot(f,dom);
    ezplot(g,dom);
    plot(abscisas,ordenadas,'r*');
    hold off
end
clear



