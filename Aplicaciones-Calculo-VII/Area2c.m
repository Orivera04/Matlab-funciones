function Area2c(f,g)


% Esta función calcula el área entre dos curvas que se interceptan en dos
% puntos comunes, aplicable cuando las rebanadas se hacen en forma vertical.
% debe pasarse como parametro las funciones Area2c1(f(x),g(x))previa
% definicion de la variable simbolica x.


% Calcula los puntos de intersección
a = solve(f - g);

% Evalua un punto muestra incluido en el intervalo

m=double(subs(f, a(1)+0.1));
n=double(subs(g, a(1)+0.1));

% verifica el valor mayor para restarlo con el menor e impirme el 
% resultado
if m < n 
    disp(int(g - f, a(1), a(2)));
else
    disp(int(f - g, a(1), a(2)));
end     
