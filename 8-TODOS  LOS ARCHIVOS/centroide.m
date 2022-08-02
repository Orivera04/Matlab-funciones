function centroide(f,g,a,b)

% Esta funcion calcula el centroide entre las curvas f(x) y g(x), en donde
% dichas funciones se pasan como parametro desde la linea de comandos de la
% siguiente forma: syms x;centroide(f(x), g(x),a,b)donde a es el limite
% inferior y b el limite superior.
syms x;

% Se deja la funcion dependiendo de x
f  = solve(f, 'y');
g  = solve(g, 'y');


% Verifca si f(x)<g(x) y realiza la resta
if  double(subs(f, 'x', a)) < double(subs(g, 'x', a))     
    s = g - f;
    s1= g^2 - f^2;
    d=0.05;
else
    s = f - g;
    s1= f^2 - g^2;
    d=-0.05;
end    

% Calcula el centroide   
v(1) = int(x*s,a,b)/int(s,a,b);
v(2) = 1/2*int(s1,a,b)/int(s,a,b);
coordenada_x=double(v(1))
coordenada_y=double(v(2))
%Grafica el centro de masa y la región de la lámina
hold on;
u=a -1: .01: b+1;
plot(u,real(subs(f,'x',u)),'r',u,real(subs(g,'x',u))+d,'k');
for i=a:.01:b;
    line([i, i]', [subs(g,'x',i), subs(f,'x',i)]', 'color', 'y');
end  
title('El centroide de la región se representa con un * ');
h=legend( 'función f ','función g ',2);
axis([-5,5,-5,5]),
line([-5 0; 5 0], [0 -5; 0 5],'LineStyle','-');
m=subs(f,x,a); n=subs(g,x,a);p=subs(g,x,b);q=subs(f,x,b);
line([a a],[m n]); line([b b], [p q]);
text(double(v(1)),double(v(2)),'*');
