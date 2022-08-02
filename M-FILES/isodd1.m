function b = isodd1(x)
%ISODD1  verdadero para Nos. impares
   if ~isnumeric(x)
      error('El argumento debe ser un arreglo numérico.');
   end               
   b = mod(x, 2) == 1;
         