function f=frec(v)
%Programa para contar frecuencias en un vector v
n=numel(v);
%Conteo de frecuencias
k=1;
val=v(1);
f(1)=1;
valrep(1)=v(1);
for i=2:n
    if val ==v(i)
        f(k)=f(k)+1;
    else
        k=k+1;
        f(k)=1;
        valrep(k)=v(i);
        val=v(i);
    end
end
%valrep
f