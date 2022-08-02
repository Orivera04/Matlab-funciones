% Calcular la suma de n numeros, la cantidad de numeros a sumar debe ser
% introducida por el usuario al igual que cada numero que se vaya a sumar
clc
suma=0;
n=input('¿Cuantos numeros desea sumar?: ');
for i=1:n
    fprintf('Numero %d : ',i);
    num=input('');
    suma=suma+num;
end
fprintf('\nLa suma es: %d\n\n',suma);