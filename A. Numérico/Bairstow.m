% Práctica 10.6: Calcula, mediante el método de Bairstow, un par de 
% raíces (no necesariamente complejas) de un polinomio. Pide los 
% datos por pantalla.
a=input('Vector de coeficientes del polinomio (de mayor a menor grado) ');
n=length(a);
disp('Valores iniciales: ');
u=input('                u= ');
v=input('                v= ');
iter=input('Número máximo de iteraciones ');
prec=input('Precision deseada ');
disp(' ')
b(n)=a(1);   %
c(n)=0;      % no dependen de u ni de v
c(n-1)=a(1); %
sw=1;
for it=1:iter
	b(n-1)=a(2)+u*b(n);
	for k=n-2:-1:1
	   b(k)=a(n-k+1)+u*b(k+1)+v*b(k+2);
	   c(k)=b(k+1)+u*c(k+1)+v*c(k+2);
	end
	det=c(1)*c(3)-c(2)*c(2);		% determinante
	deltau=(c(2)*b(2)-c(3)*b(1))/det;
   deltav=(c(2)*b(1)-c(1)*b(2))/det;
   u=u+deltau;
	v=v+deltav;
   disp(sprintf('iteración %i, u= %d, v= %d',it,u,v))
	norma=norm([deltau,deltav]);
   if norma<prec
      disp(' ')
      disp('El valor aproximado de las dos raíces es:')
      x1=(u+sqrt(u^2+4*v))/2
      x2=(u-sqrt(u^2+4*v))/2
      sw=0;
      break
   end
end
if sw
   disp('Alcanzado el máximo de iteraciones sin obtenerse convergencia.')
end

   


