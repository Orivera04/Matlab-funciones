%Interceptos y simetr�as de las gr�ficas de ecuaciones de la forma
%f(x,y)=0.

clc;
%Introducir la funci�n f
f=input('Introduzca f como una funci�n inline: f(x,y)= ');
syms s t;

%Hallar los inteceptos con el eje x
Ix=solve(f(x,0));
Ixreal=Ix(imag(Ix)==0);
n=numel(Ixreal);

%Hallar los interceptos con el eje y
Iy=solve(f(0,y));
Iyreal=Iy(imag(Iy)==0);
m=numel(Iyreal);

%Determinar la simetr�a respecto al eje x
if f(s,t)==f(s,-t) 
    disp('La gr�fica es sim�trica con respecto al eje x')
else
    disp('La gr�fica no es sim�trica con respecto al eje x')
end

%Determinar la simetr�a respecto al eje y
if f(s,t)==f(-s,t)
    disp('La gr�fica es sim�trica con respecto al eje y')
else
     disp('La gr�fica no es sim�trica con respecto al eje y')
end

%Determinar la simetr�a respecto al origen
if f(s,t)==f(-s,-t)
    disp('La gr�fica es sim�trica con respecto al origen')
else
 disp('La gr�fica no es sim�trica con respecto al eje y')
end
ezplot(f)
hold on
