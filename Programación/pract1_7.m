%Práctica 1.7: Cálculo del épsilon de la máquina.
x=1;
while 1+x>1
   x=x/2;
end
x=2*x;
disp('El épsilon de la máquina es')
disp(x)
disp('El valor de 2^(-52) es')  % Comprobación
disp(2^(-52))
