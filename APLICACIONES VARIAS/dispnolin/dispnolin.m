function [Y,k,t]=dispnolin(f,a,b,alfa,beta,n,tol,maxiter)

% [Y,k,t]=dispnolin('u',a,b,alfa,beta,n,tol,maxiter)
% Metodo de disparo pra PVF no lineal, aplicando el metodo de la secante
% Y: solucion aproximada del PVF
% u: sistema del PVF (aqui lo que lo convierte en un PVI son las
% condiciones iniciales)
% a,b: extremos intervalo variable independiente x
% alfa: condicion PVF en a
% beta: condicion PVF en b
% n: numero de nodos entre a y b

t=[0 1];                       % Valores iniciales del parametro t (arbitrarios)
f0=[alfa t(1)];               % Condiciones inicials PVI equivalente [y(a) y'(a)]

[q,sol]=rungkutm(f,a,b,f0,n);        % Primera estimacion de la solucion con t=t0
y(:,1)=sol(:,1);
incr(1)=abs(y(n+1,1)-beta);
if incr(1)<tol
    Y=y(:,1);
else
    f1=[alfa t(2)];
    [q,sol]=rungkutm(f,a,b,f1,n);       % Segunda estimacion de la solucion
    y(:,2)=sol(:,1);
    incr(2)=abs(y(n+1,2)-beta);         % Aproximacion a la solucion
    if incr(2)<tol
        Y=y(:,2);
    else
        k=2;
        while incr(k)>=tol & k<=maxiter
            t(k+1)=t(k)-((t(k)-t(k-1))*incr(k))/(incr(k)-incr(k-1));
            k=k+1;
            fk=[alfa t(k)];
            [q,sol]=rungkutm(f,a,b,fk,n);
            y(:,k)=sol(:,1);
            incr(k)=abs(y(n+1,k)-beta);
        end
        if k==maxiter
            disp('No se encuentra la solucion con las iteraciones dadas')
        else
            Y=y(:,k);
        end
    end
end

plot(q,Y);