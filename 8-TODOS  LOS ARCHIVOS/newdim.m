function  [P, iter, err] = newdim (F, JF, P, delta, epsilon, max1)

% Entrada  - F es el sistema guardado como el archivo-M  F.m
%          - JF es el Jacobiano de  F  guardado como el archivo-M  JF.M
%          - P es la aproximacion inicial a la soluion
%          - delta es la tolerancia para  P
%          - epsilon es la tolerancia para  F(P)
%          - max1 es el numero maximo de iteraciones
% Salida   - P es la aproximacion a la solucion
%          - iter es el numero de iteraciones realizadas
%          - err es el error estimado para  P

%  METODOS NUMERICOS: Programas en Matlab
% (c) 2004 por John H. Mathews y Kurtis D. Fink
%  Software complementario acompañando al texto:
%  METODOS NUMERICOS con Matlab, Cuarta Edicion
%  ISBN: 0-13-065248-2
%  Prentice-Hall Pub. Inc.
%  One Lake Street
%  Upper Saddle River, NJ 07458

Y = feval(F, P);

for  k = 1:max1
   J = feval(JF, P);
   Q = P - (J \ Y')';
   Z = feval(F, Q);
   err = norm(Q - P);
   relerr = err / (norm(Q) + eps);
   P = Q;
   Y = Z;
   iter = k;
   if  (err < delta)  |  (relerr < delta)  |  (abs(Y) < epsilon)
     break
   end
end
