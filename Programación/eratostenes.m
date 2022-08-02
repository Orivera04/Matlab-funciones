% Por: Rommel José Briones Mena 
% Este programa calcula todos los numeros primos menores que el numero
% introducido por el usuario por medio del Algoritmo de la Criba de Eratóstenes
% Algoritmo:
% Para todos los numeros menores que n hacer
%   tachar los multiplos de 2, 3, 5 y 7
%   imprimir los restantes.
% fin
function c = eratostenes(n)
%clc;
%n=input('Introduzca el numero maximo a evaluar:  >> ');
arr=1:1:n;
i=2;
while i<=7
     j=1;
    while j<=n
        res=mod(arr(j),i);
        div=arr(j)/i;
         if (res == 0) & (div > 1)
             arr(j)=0;
         end
         j=j+1;        
     end
     i=i+1;
end
%fprintf('\nLos numeros primos menores que %d:\n\n',n);
j=1;
c=[];
while j<=n
    if arr(j)~=0
      c=[c,arr(j)];  
    end
    j=j+1;
end
%disp(c);