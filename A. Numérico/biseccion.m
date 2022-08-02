%%%%%%%%%%%%%%%%%%   M�TODO DE LA BISECCI�N      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%   Para implementar en MATLAB EDITAR ARCHIVO COMO .m %%%%%%%%%  

function  x = biseccion(fun,a,b,tol)
% Aproxima por el m�todo  de la bisecci�n una ra�z de la ecuaci�n fun(x)=0
disp('M�todo de la bisecci�n');
u=feval(fun,a); %no aparece por pantalla el valor de u, pero s� el de f(a)
v=feval(fun,b); %idem anterior
n=1; %n�mweo de iteraciones
if sign(u)==sign(v)
   disp('Error la funci�n debe cambiar de signo en (a,b)');
   break; 
end 
while ((b-a)*0.5>tol)
   c=(b+a)/2; w=feval(fun,c);
   disp(['n=', num2str(n)]);
   disp(['c=', num2str(c)]);
   disp(['f(c)=', num2str(w)]);
if sign(u)==sign(w)
	a = c; u=w;
else
	b=c; v=w;
end
	n=n+1;
end;
x=c

