%Este programa calcula el promedio de 5 numeros que son introducidos por el usuario

clc                                             %Limpiar el espacio de trabajo
num1=input('Introduzca el primer numero:   ');  %Leer el primer numero
num2=input('Introduzca el segundo numero:  ');  %Leer el segundo numero
num3=input('Introduzca el tercer numero:   ');  %Leer el tercer numero
num4=input('Introduzca el cuarto numero:   ');  %Leer el cuarto numero
num5=input('Introduzca el quinto numero:   ');  %Leer el quinto numero
prom=(num1+num2+num3+num4+num5)/5;              %promedio = suma de los numeros ÷ 5
fprintf('El promedio es %f',prom);              %imprimir el promedio