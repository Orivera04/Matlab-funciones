%Programa para leer e imprimer arreglos
%Lectura del arreglo A
clear A;
for i=1:3
    for j=1:3
        fprintf('A(%2.0f,%2.0f)= ',i,j);
        A(i,j)= input('');
    end
end
 %Visualizacion del arreglo
 fprintf('La matriz A es : \n');
 for i=1:3
     for j=1:3
         fprintf(' %4.0f ',A(i,j))
     end
     fprintf('\n')
 end
 