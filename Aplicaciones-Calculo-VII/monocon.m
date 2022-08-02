%Programa para determinar los intervalos donde una función continua
%es creciente, donde es decreciente,donde es cóncava hacia arriba o
%hacia abajo. Hecho por R. Briones. UNI. Managua. Nicaragua. 07/2012.

%Introducir la función y su dominio.
clc
syms x
f=input('La función f es f(x)= ');
dominio=input('El dominio de f es: [a,b]= ');

%Hallar la 1a. y 2a. derivadas.
fx=diff(f)
fxx=diff(fx)

%Hallar puntos críticos de 1a. y 2a. especie
pc1e=double(solve(fx))
n=numel(pc1e)
pc2e=solve(fxx)
delta=input('delta= ');
%Hallar ptos. medios entre ptos. críticos.

switch n
    case 0
    disp('No hay ptos. críticos de 1a. especie')
    med=(a+b)/2;
    fmed=subs(f,x,med);
    fmed1=subs(f,x,med+delta);
    if fmed >=0 & fmed1>=0
        disp('f es creciente en todo su dominio')
    elseif fmed <=0 & fmed <=0
        disp('f es decreciente en todo su domino')
    end
    case 1
    fx1=double(subs(fx,x,pc1e-delta))
    fx2=double(subs(fx,x,pc1e+delta))
    if(fx1 < 0  & fx2 > 0)
        disp('f es decreciente en [a,pc1e)')
        disp('f es creciente en (pc1e,b]')
    elseif (fx1 > 0 & fx2 < 0)
        disp('f es creciente en [a,b)')
        disp('f es decreciente en (a,b]')
    elseif(fx1 > 0 & fx2 >0)
        disp('f es creciente en todo su dominio')
    elseif(fx1 < 0 & fx2 <0)
        disp('f es decreciene en todo su dominio')
    else
        disp('f no es estrictamente monótona en todo [a,b]')
    end
    
    otherwise
        
    for i=1:n
       
       fx1=double(subs(fx,x,pc1e(i)-delta))
       fx2=double(subs(fx,x,pc1e(i)+delta))
       if(fx1 > 0 & fx2 <0)
           disp('f es creciente en [a,pc1e(i))')
           disp('f es decreciente en (pc1e(i),b]')
       elseif(fx1 <0 & fx2 > 0)
           disp('f es decreciente en [a,pc1e(i))')
           disp('f es creciente en (pc1e(i),b]')
       elseif(fx1>=0 & fx2>=0)
           disp('f es creciente en [a,b]')
       elseif(fx1<=0 & fx2 <=0)
           disp('f es decreciente en [a,b]')
       else
           disp(' ')
       end
    end

end
clear