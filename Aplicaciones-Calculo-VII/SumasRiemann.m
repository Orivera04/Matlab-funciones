%Sumas de Riemann con los ptos intermedios de una partici�n regular 
%abtenidos de n�meros aleatorios uniformes.

% Dar intervalo [a,b] y No. de ptos. de la partici�n.
a=input('a= ');
b=input('b= ');
n=input('No. de ptos. de la partici�n: ');

%Dar la funci�n f
fun=input('f(x)= ');
f=inline(fun);

%Dar la particion P y los delta x
x=linspace(a,b,n);
deltax=(b-a)/(n-1);

%Calcular sumas de Riemann para la partici�n dada 
% y los ptos intermedios obtenidos aleatoriamente.
SRiemann=0;
for i=1:n-1
    xbarra=x(i)+deltax*rand(1);
    SRiemann=SRiemann+f(xbarra)*deltax;
end
SRiemann
    


