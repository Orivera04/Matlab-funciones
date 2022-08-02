fprintf('i\tNúmero     \tcuadrado   \tRaíz    \n');
i=1;
x=0;
while i<=10
  x=x+1;  
  raiz=sqrt(x);
  cuadrado=x*x;
      fprintf('%d\t%f\t%f\t%f\n',i,x,cuadrado,raiz);
      i=i+1;
end 