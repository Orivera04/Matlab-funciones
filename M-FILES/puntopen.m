function y=puntopen(x)
%Ecuación de la recta en la forma punto pendiente
%Introducir la pendiente y el intercepto con eje y
m=input('pendiente= ');
b=input('intercepto= ');
ec=char(inline('m*x+b','m','b','x'));
y=eval(ec);
end