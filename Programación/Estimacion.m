%fprintf('i\tNumero1\tNumero2\tRaiz\tX');
i=1;
%while i<=10
  x=0;
  num1=rand;
  num2=rand;
  raiz=sqrt((num1^2)+(num2^2));
 % if raiz<1
     x=x+1;
     fprintf('%d\t%f\t%f\t%f\t%d',i,num1,num2,raiz,x);
     i=i+1;
  %end
%end 