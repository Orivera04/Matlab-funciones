clc;
valor=input('Introduzca un valor entero de 4 digitos: >> ');
mil=floor(valor/1000);
valor=valor-(mil*1000);
cien=floor(valor/100);
valor=valor-(cien*100);
diez=floor(valor/10);
valor=valor-(diez*10);
fprintf('\nLa valor es %d%d:%d%d',mil,cien,diez,valor);