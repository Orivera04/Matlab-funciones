%Interceptos y simetrías de las gráficas de ecuaciones de la forma
%f(x,y)=0.

clc;
%Introducir la función f
f=input('Introduzca f como una función inline: f(x,y)= ');
syms s t;

%Hallar los inteceptos con el eje x
Ix=solve(f(x,0));
Ixreal=Ix(imag(Ix)==0);
n=numel(Ixreal);

%Hallar los interceptos con el eje y
Iy=solve(f(0,y));
Iyreal=Iy(imag(Iy)==0);
m=numel(Iyreal);

%Determinar la simetría respecto al eje x
if f(s,t)==f(s,-t) 
    disp('La gráfica es simétrica con respecto al eje x')
else
    disp('La gráfica no es simétrica con respecto al eje x')
end

%Determinar la simetría respecto al eje y
if f(s,t)==f(-s,t)
    disp('La gráfica es simétrica con respecto al eje y')
else
     disp('La gráfica no es simétrica con respecto al eje y')
end

%Determinar la simetría respecto al origen
if f(s,t)==f(-s,-t)
    disp('La gráfica es simétrica con respecto al origen')
else
 disp('La gráfica no es simétrica con respecto al eje y')
end
ezplot(f)
hold on
