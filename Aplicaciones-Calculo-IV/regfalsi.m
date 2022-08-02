function solaprox = regfalsi(f,a,b,iter)
%Metodo de la regula falsi
g = inline(f);
if g(a)*g(b) >= 0
    disp('No se cumple la condicion f(a)*f(b)<0.');
    disp('Cambiar el valor de a, de b o de ambos')
else
for i=1:iter
    w=(g(b)*a - fun(a)*b)/(g(b) - g(a));
if g(a)*g(w) <= 0
    b=w
else
    a=w
end; 
end;
solaprox=b;
fprintf('la solucion de f(x)=0 esta en el intervalo [%10.2f %10.2f]',a,b)
end