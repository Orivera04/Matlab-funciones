%Programa para calcular m�ximos y m�nimos locales de una funci�n de 
%una variable usando el criterio de la primera derivada

%introducir la funci�n f y el dominio de la misma 
clc
syms x;
f=input('La funci�n f es: f(x)= ');
dom=input('El dominio de f es: [a,b]= ');

%Hallar la 1a derivada de f
fx=diff(f)

%hallar los ptos. cr�ticos de f
pc=solve(fx);
pcd=double(pc);
n=numel(pc)
valf=subs(f,x,pcd);
%Casos de estudio:
delta_x=input('Dar un delta_x: ');
switch n
    case 0
        disp('No hay ptos. cr�ticos')
        disp('f no tiene m�ximos ni m�nimos locales')
    otherwise
        pcrep=pcd(1)+delta_x;
        for i=1:n
            if pcd(i)~=pcrep
            valfxi=double(subs(fx,x,pc(i)-delta_x));
            valfxd=double(subs(fx,x,pc(i)+delta_x));
            valfx=double(subs(f,x,pcd(i)));
            if( valfxi < 0 & valfxd >0)
                fprintf('f tiene un m�nimo local en %f\n',pcd(i));
                pcrep=pcd(i);
            elseif( valfxi > 0 & valfxd < 0)
                fprintf('f tiene un m�ximo local en %f\n',pcd(i)) 
                pcrep=pcd(i);
            else
                fprintf('f tiene un punto silla en %f\n',pcd(i))
                pcrep=pcd(i);
            end
            else
                continue
            end
        end
end
hold on
ezplot(f,dom)
grid on
plot(pcd,valf,'r*')
hold off
    
 