%lista
n = input('Deme el No. de filas ');
disp('Matriz de tres columnas');
for i=1:3:n*3
    fprintf('%5.0f %5.0f %5.0f\n',i,i+1,i+2)
end