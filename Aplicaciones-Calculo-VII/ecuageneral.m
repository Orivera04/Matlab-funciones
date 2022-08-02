%Programa para graficar una recta a partir de su ecuación general.
A=input('De el valor de A: ')
B=input('De el valor de B: ')
C=input('De el valor de C: ')
syms x y
if A==0 & B==0 & C==0
    disp('No hay recta')

elseif A==0 & B==0
    disp('No hay recta')

elseif A==0 & C==0
   disp('La ecuación de la recta es: ')
    y=0
line([0 3],[0 0])
elseif B==0 & C==0 
  disp('La ecuación de la recta es: ') 
    x=0
    line([0 0],[0 3])
elseif A==0 
  disp('La ecuación de la recta es: ')  
    y=-C/B
    line([0 5],[-C/B -C/B])
elseif B==0
   disp('La ecuación de la recta es: ') 
    x=-C/A
    line([-C/A -C/A],[0 5])
elseif C==0
   disp('La ecuación de la recta es: ') 
    y=(-A/B)*x
    line([0 1],[0 -A/B])
    else
   disp('La ecuación de la recta es: ')
   y=-C/B-A/B*x
   line( [0 1],[-C/B -(A+C)/B])
end
    
        