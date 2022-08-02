%Programa para imprimir Nos. impares desde 1 hasta n
clc
n=input('Dar el valor máximo de n: ');


disp('Los Nos. impares desde 1 hasta n son:');
disp(1);
for i=1:n
    if rem(20,i)==0
        continue
    else
        disp(i)
    end
end