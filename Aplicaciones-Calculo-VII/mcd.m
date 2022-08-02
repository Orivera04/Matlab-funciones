% Maximo Comun Divisor utilizando funcion recursiva
%
% z = mcd (x,y)
%
% x,y : numeros enteros
% z : Maximo Comun Divisor de x e y

function z = mcd (x,y)

    if (x<y)
        z = mcd (y,x);
    elseif y==0
        z = x;
    else
        z = mcd (y, rem (x,y) );
    end
    