
clc;
n=input('¿Cuántas iteraciones desea realizar?:  >> ');
fprintf('i\tNumero1\t\tNumero2\t\t  Raiz\t\t<1\tX\tEstimación de Pi\n');
fprintf('----------------------------------------------------------------------------------------\n');
equis=1:1:n;
yes=zeros(1,n);
pis=zeros(1,n);
i=1;
x=0;
while i<=n
  num1=rand;
  num2=rand;
  raiz=sqrt((num1^2)+(num2^2));
  estpi=4*(x/i);
  yes(i)=estpi;
  pis(i)=pi;
  if raiz<1
     x=x+1;
     fprintf('%d\t%f\t%f\t%f\tSI\t%d\t    %f\n',i,num1,num2,raiz,x,estpi);
  end
  if raiz>=1
     fprintf('%d\t%f\t%f\t%f\tNO\t%d\t    %f\n',i,num1,num2,raiz,x,estpi);
  end
  if rem(i,30)==0 & i~=n
     fprintf('Presione una tecla para continuar...\n');
     pause(2);
  end
i=i+1;
end 

plot(equis,yes,'r-',equis,pis,'g-'),xlabel('Iteración'),ylabel('Estimación de Pi'),...
   axis([1 n/4 1 5]),title('Gráfica de Estimación de PI'),grid;