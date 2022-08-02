fprintf('Las notas son:\n');
for i=1:2
    for j=1:2
        fprintf('notas(%2.0f, %2.0f)',i,j);
        notas(i,j)=input('=');
    end
end;
fprintf('La visualizacion de las notas\n')
for i=1:2
    for j=1:2
        fprintf('notas(%2.0f,%2.0f)= %4.2f\n ',i,j,notas(i,j));
    end
end
        
        

        