function centrom(f, a, b)
% Esta funcion calcula el centro de masa de una lamina homogenea con densidad rho = 1
% se debe digitar desde la linea de comandos la sentencia syms
% x;centrom(f(x), a, b)siendo f(x) la ecuacion a evaluar, a el limite
% inferior y b el limite superior.

syms x;

% Calcula la masa de la lamina
m = int(f,a,b);

% Calcula los momentos Mx y My
Mx = 1/2*int(f^2,a,b);
My = int(x*f,a,b);

% Calcula el centro de masa
v(1) = My/m;
v(2) = Mx/m;
disp(v);

c =['y = ',char(f)];
u=-2:.01:2;

%Grafica el centro de masa y la región de la lámina

plot(u,double(subs(f,'x',u))),title('Centro de masa de una lamina'),
text(b+0.5,subs(f,'x',b)+0.5,c);
axis([-5,5,-5,5]),
text(double(v(1)),double(v(2)),'*');
line([-5 0; 5 0], [0 -5; 0 5],'LineStyle','-');
line([a, a]', [0, subs(f,'x',a)]', 'color', 'r');
line([b, b]', [0, subs(f,'x',b)]', 'color', 'r');
