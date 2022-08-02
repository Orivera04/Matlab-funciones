% Práctica 1.12: Sucesión inestable.
format long
format compact
x=1;
disp('Iteración número')
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
   disp('Iteración número')
   disp(i)
   disp('      Calculado       Potencias de 1/7') 
   disp([y pot])
   disp(' ')
end
format
