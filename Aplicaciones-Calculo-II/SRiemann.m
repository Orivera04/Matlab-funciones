%Sumas de Riemann  de una partici�n no regular. Los ptos. intermedios 
%son dados
clear;
clc;

% Dar intervalo [a,b] y No. de ptos. de la partici�n.
a=input('a= ');
b=input('b= ');
n=input('No. de ptos. de la partici�n: ');

%Dar la funci�n f
fun=input('f(x)= ');
f=inline(fun);

%Dar la particion P y obtener los delta x
disp('Introducir los ptos de la partici�n ');
for i=1:n
    fprintf('Pto. No. %d',i);
    x(i)=input(' \n ');  
end  
x
deltax=diff(x)
disp('Introducir los ptos xbarra ');
%Introducir los xbarra
for i=1:n-1
    fprintf('Pto. No. %d',i);
    x(i)=input(' \n ');  
end  

%Calcular sumas de Riemann para la partici�n dada 
% y los ptos intermedios obtenidos aleatoriamente.
SumaRiemann=0;
for i=1:n-1
    xbarra=x(i)+deltax(i)*rand(1);
    SumaRiemann=SumaRiemann+f(xbarra)*deltax(i);
end
SumaRiemann