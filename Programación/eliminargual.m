function v=elimigual(x)
%Elimina componentes que son iguales en un vector,solo deja una copia de
%cada componente. Al transformar [1 1 2 2 3 3] queda: [1 2 3]
clear;
clc;
x=sort(x);
n=numel(x);
y(1)=x(1);
e1=x(1);
k=2;
while k < n
    for i=k:n
    if e1==x(i)
        y(i)= inf;
    else
        y(i)=x(i);
    end
    end
    e1=x(k);
    k=k+1;
end

p=0;
for i=1:n
    if y(i)== inf
      continue   
    else
 p=p+1;
 v(p)=y(i);
    end
end

