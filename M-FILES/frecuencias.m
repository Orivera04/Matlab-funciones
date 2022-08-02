%Programa para contar frecuencias de valores repertidos en un
%vector de tamaño n.

%Introducir el vector v
v=input('Introduzca el vector v:')
n=numel(v);

%Conteo de frecuencias
k=1;
val=v(1);
frec(1)=1;
valrep(1)=v(1);
for i=2:n
    if val ==v(i)
        frec(k)=frec(k)+1;
    else
        k=k+1;
        frec(k)=1;
        valrep(k)=v(i);
        val=v(i);
    end
end
valrep
frec