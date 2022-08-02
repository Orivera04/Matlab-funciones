function reglatrap(f,a,b,n)

% Calcula una integral en forma numérica utilizando el metodo de la regla
% trapezoidal  al cual le pasamos como parametros la funcion, los limtes
% de integracion y el numero de regiones en que subdibidiremos el area.
% Desde la linea de comandos debe definir la variable simbolica x, y la funcion 
% reglatrap(f,a,b,n) 



h = (b-a)/n;

%Calculamos el valor de f(x) para cada i

i=a:h:b;
y = subs(f,'x',i);
tam = size(y,2);
i=y;

% Quitamos el primer y ultimo elemento del vector

y(:,1)=[ ];
y(:,tam-1)=[ ];

% Regla trapezoidal

In = h*(i(1)+2*sum(y)+i(tam))/2;
disp(['El resultado es = ',char(num2str(In,6))]);
