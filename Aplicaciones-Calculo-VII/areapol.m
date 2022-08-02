function Areapol(f,a,b,n)

% esta funcion lee del teclado la formula, y los valores extremos de la curva en
% cuestion asi como el valor de los subintervalos.
% defina variable simbolica x desde la linea de comandos.


% definimos la variable simbolica
syms k ;

% encontramos el valor de la distancia entre xk-1 y xk
deltax = (b - a)/n; 

% sustituimos el valor encontrado en la funcion f
u = subs(f,'x',deltax*k);


% realizamos la suma simbolica
s1=symsum(u*deltax,1, n);

% mostramos el resultado
disp(s1);
