function raiz = bisec(f,a,b,iter)
%Metodo de la biseccion
for i=1:iter
    m=(a+b)/2;
    x=a;
    val1=eval(f);
    x=m;
    val2=eval(f);
    if val1*val2 <= 0
        b=m;
    else
        a=m;
    end;
end;
fprintf('La raiz esta en el intervalo [%12.10f  %12.10f]',[a b]);


    
