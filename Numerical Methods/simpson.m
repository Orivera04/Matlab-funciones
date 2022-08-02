function simpson();
% Este programa solicita la funcion, los limites de integracion y tolerancia
% para calcular la integral definida por medio de la regla de Simpson
% usando el metodo mas conveniente.


clear;clc
%Ingreso de datos
disp('Regla de simpson')
disp('Integrales definidas')
fx=input('digite la funcion f(x) = ','s');
a=input('limite inferior = ');
b=input('limite superior = ');
tol=input('tolerancia = ');
%Condiciones iniciales
err(1)=100;ns=2;exito=0;syms x;
%Calculo de la integral
while exito==0
    h=(b-a)/ns;
    x=a:h:b;
    y=subs(fx,x);
    if (rem(ns,3)==0) %simpson 3/8
        Iaprox(ns-1)=3*h/8*(y(1)+y(ns+1)+3*sum(y(2:3:ns-1))+3*sum(y(3:3:ns))+2*sum(y(4:3:ns-2)));
    elseif (rem(ns,2)==0) %simpson 1/3
        Iaprox(ns-1)=h/3*(y(1)+y(ns+1)+4*sum(y(2:2:ns))+2*sum(y(3:2:ns-1)));
    else % combinacion 3/8 + 1/3
        Iaprox(ns-1)=h/3*(y(1)+y(ns-2)+4*sum(y(2:2:ns-3))+2*sum(y(3:2:ns-4)))+3*h/8*(y(ns-2)+3*y(ns-1)+3*y(ns)+y(ns+1));
    end 
    if ns>2 % calculo del error
        err(ns-1)=abs((Iaprox(ns-1)-Iaprox(ns-2))/Iaprox(ns-1))*100;
        if err(ns-1)<tol
            exito=1;
            break;
        end
    end
    ns=ns+1;
end
%Presentacion de resultados
n=2:ns;
fprintf('\n');
disp(['     segm'   '      integ'  '      error'])
disp([n' Iaprox' err' ]);
fprintf('\n se alcanzo la solucion con % g segmentos \n',ns);
fprintf('\n la integral aproximada es %g \n',Iaprox(ns-1));




