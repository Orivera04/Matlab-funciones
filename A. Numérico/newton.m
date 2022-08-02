function [res, it] = newton(func, dfunc, x, precis)
%x0 es el valor inicial de x
%precis es la precision requerida
%func es la funcion f y dfunc es su derivada
it = 0; x0 = x;
d = feval(func, x0)/(dfunc,x0);
while abs(d)>precis
    x1 = x0-d;
    it = it + 1;
    x0 = x1;
    d = feval(func, x0)/feval(dfunc,xo);
end;
res = x0;