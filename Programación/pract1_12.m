% Pr�ctica 1.12: Sucesi�n inestable.
format long
format compact
x=1;
disp('Iteraci�n n�mero')
disp(1)
disp('      Calculado       Potencias de 1/7') 
disp([1/7 1/7])
disp(' ')
y=1/7;
pot=y;
for i=2:100
   aux=y;
   y=(22/7)*y-(3/7)*x;
   x=aux;
   pot=pot/7;
   disp('Iteraci�n n�mero')
   disp(i)
   disp('      Calculado       Potencias de 1/7') 
   disp([y pot])
   disp(' ')
end
format
