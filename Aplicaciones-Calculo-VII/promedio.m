%Programa para leer notas, calcular promedio y contar notas menores que
%promedio
%
%Lectura de notas
clear notas;
for i= 1:5
    fprintf('Deme la nota %2.0f \n  ',i);
    notas(i)= input('nota = ');
end;
suma = 0;
%Calculo del promedio
for i = 1:5
    suma = suma + notas(i);
end;
prom = suma/5;
fprintf('el promedio es: %4.2f \n ',prom);
%Conteo de notas menores que promedio
k = 0;
for i = 1:5
    if notas(i) < prom
      k = k + 1;
    end;
end
fprintf('El No. de notas menores que el promedio es %2.0f \n',k)


  


