%function [raiz, it] = newton(func,x,precis)
%xo es el valor inicial, precis es la precision requerida 
%func es la funcion y dfunc es su derivada.
func = 'x^2 - x - sin(x-0.15)';
it = 0; x = 1.5; precis = 0.0001;
der = diff(func);
d = eval(func)/eval(der);
while abs(d) > precis
    x1 = x - d;
    it = it +1;
    x = x1;
    d = eval(func)/eval(der);
end;
raiz = x;
raiz
