%Programa para evaluar sumas de Riemann

%Introducir la funci�n.
clc;
f=input('La fuci�n f (en forma inline) es: f(x)= ');

%Introducir los puntos donde se va a evaluar la funci�n.
x=input('Los puntos x_i son: ');

%Introducir los delta_x(i).
delta_x=input('Los delta_xi son: ');

%Calcular la suma de Riemann.
valfun=f(x);
disp('La suma de Riemman para esta funci�n y la partici�n x es:' ); 
producto=valfun.*delta_x;
sriemann=sum(producto');
disp(sriemann)
syms N S n s
resp=input('�Desea hacer otra corrida de este programa?: (S/N): ');
if resp == S || resp == s
    sumariemann
else
    disp('�Hasta luego!')
end