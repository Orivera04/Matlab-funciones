%Programa para hallar intersecciones y simetrías de la gráfica de una 
%función de una variable 

%Introducir la función de estudio
clc
syms x
f=input('La función a estudiar es f(x)= ');

%Introducir el itervalo donde se va a estudiar
a=input('El extremo izquierdo del dominio de f es: ');
b=input('El extremo derecho del dominio de f es: ');

%Encontrar los interceptos con eje Y
int_ejeY=subs(f,x,0);
intY=double(int_ejeY);
disp('El intercepto con el eje Y es: ')
intY

%Encontrar interceptos con eje X
int_ejeX=solve(f);
intX=double(int_ejeX);
n=numel(int_ejeX);
disp('Los interceptos con el eje X son: ')
intX

%Determinar simetría con eje Y
syms t;
famas=subs(f,x,t);
famenos=subs(f,x,-t);
if famas == famenos
    disp('f es simétrica con el eje Y')
else 
    disp('f no es simétrica con eje Y')
end

%Determinar simetría con el origen
if famenos==-famas
    disp('f es simétrica con el origen')
else
    disp('f no es simétrica con el origen')
end
%Graficar f y los interceptos con los ejes
ezplot(f,[a,b]);
hold on
plot(0,intY);
plot(intX,zeros(1,n));
grid on
hold off
clear