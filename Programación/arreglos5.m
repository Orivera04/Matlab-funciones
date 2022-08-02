%Programa para calcular el maximo elemento de un arreglo
%Lectura del arreglo
for i=1:10
    fprintf('elemento A(%2.0f)= ',i);
    A(i)= input('');
end
max = A(1);
for i=2:10
    if max <= A(i)
        max=A(i);
    end
end
fprintf('El maximo es %2.0f',max)
        