
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%   M�TODO DEL PUNTO FIJO    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%   

function  [n,p]=pfijo_error(g,p0,a,b,tol,k)
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Aproxima por el m�todo del punto fijo una raiz de fun(x)=x
% tomando como criterio abs(k^n/(1-k)*(b-a)<tol
% Variables de entrada:
%     g(x): funcion a iterar
%     p0: estimaci�n inicial para el proceso de iteraci�n
%     a,b son los extremos del intervalo
%     tol: tolerancia en error absoluto para la raiz
%     k: Cota de la derivada de g     
%
% Variables de salida:
%     n: primera iteraci�n v�lida
%     p: vector con los n itereados
%    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
n=1;
p(1)=p0;
error=(b-a); 
while (error > tol)
   p(n+1)=feval(g,p(n)); 
   error=(k^n/(1-k))*(b-a); %actualizo el error
   n=n+1;
end 
n 
p
 
