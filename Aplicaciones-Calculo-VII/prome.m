%Programa  para calcular promedios
for i=1:2
    for j=1:2
    fprintf('notas(%2.0f,%2.0f) ',i,j); 
    notas(i,j)=input(' = ');
end
end
for i=1:2
    suma=0;
    for j=1:2
        suma=suma + notas(i,j);
    end
    No_estudiante=i
    prom=suma/2
    
end

    