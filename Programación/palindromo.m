% Programa que determine si una palabra es o no palindromo
clear y;clc;
   x=input('Deme la palabra:  ')
   n=length(x);
for i=1:n
    y(i)=x(n-i+1)
end
if (x==y)
    disp('x es polindromo')
else
    disp('x no es polindromo')
end
    
       