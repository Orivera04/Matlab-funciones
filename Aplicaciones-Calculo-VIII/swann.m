% Funcion de acotacion
% Sintaxis [a,b] = acotar (f,x0,delta,N)
%
% f:        Funcion
% x0:       Punto inicial
% delta:    Desplazamiento
% N:        Maximo numero de iteraciones
% a:        Extremo inferior del intervalo
% b:        Extremo superior del intervalo

function [a,b] = acotar (f,x0,delta,N)

% Primera fase: determinacion de la direccion de decrecimiento

if feval(f,x0-delta)>feval(f,x0) & feval(f,x0)>feval(f,x0+delta)
    % Decrece hacia la derecha
else if feval(f,x0-delta)<feval(f,x0) & feval(f,x0)<feval(f,x0+delta)
        % Decrece hacia la izquierda
        delta = -delta; 
    else if feval(f,x0-delta)>feval(f,x0) & feval(f,x0)<feval(f,x0+delta)
            % Hemos encontrado el intervalo
            a = x0-delta;
            b = x0+delta;
            return;
        else
            % La funcion no es unimodal
            disp('La funcion no es unimodal')
            a = [];
            b = [];
            return;
        end
    end
end

% Segunda fase: calculo de puntos y comprobaciones

x(1)=x0;
x(2)=x(1)+delta;

for k=3:N
    x(k)=x(k-1)+2^(k-2)*delta;
    if feval(f,x(k))>feval(f,x(k-1))
        a = x(k-2);
        b = x(k);
        return;
    end
end

% Si hemos llegado hasta aqui, es porque no lo hemos encontrado
disp('Intervalo no encontrado')
a=[];
b=a;