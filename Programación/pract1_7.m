%Pr�ctica 1.7: C�lculo del �psilon de la m�quina.
x=1;
while 1+x>1
   x=x/2;
end
x=2*x;
disp('El �psilon de la m�quina es')
disp(x)
disp('El valor de 2^(-52) es')  % Comprobaci�n
disp(2^(-52))
