function ec_normal(fi,xo,yo)
%Ecuación normalizada de la recta que pasa por el punto (xo,yo)y es
%perpendicular al vector n que forma un angulo fi con el eje positivo x

p = -sqrt(xo^2+yo^2);
ang=pi*fi/180;
a=cos(ang);
b=sin(ang);
syms x y
disp(['El punto de la recta es: M(',num2str(xo),',',num2str(yo),')'])
disp(['El ángulo fi es: ',num2str(fi)])
fprintf('La ecuación normal es: %4.2f*x %+4.2f*y %+4.2f = 0\n',a,b,p);
