%Programa que crea una tabla de valores de una funci�n.
%En este caso tabla de valores de la funci�n exponencial.
%
x = 0:.1:1; 
  y = exp(x);
  disp('Tabla # 1');
  disp(' x         exp(x)');
  fprintf('\n %6.4f   %6.4f  ',[x; y]);
  fprintf('\n')