function Area2c1(f,g)
% Esta función calcula el área entre dos curvas que se intersecan en dos
% puntos comunes, aplicable para cuando las rebanadas del area se hacen en forma horizontal.
% debe pasarse como parametro las funciones Area2c1(f(x),g(x))previa
% definicion de la variable simbolica x.

%encuentra los puntos de intersección de las curvas
[x,y]=solve(g,f);

%para integrar horizontalmente despejamos x en ambas curvas

f = solve(f, 'x');
g = solve(g, 'x');

%evaluamos un punto incluido en el subintervalo por cada curva

m=double(subs(f, y(1)+0.1));
n=double(subs(g, y(1)+0.1));


%Evalua el valor más grande de x para restarlo al más pequeño 

if m < n    
    disp(double(int(g - f, y(1), y(2))));
else
    disp(double(int(f - g, y(1), y(2))));
end    
