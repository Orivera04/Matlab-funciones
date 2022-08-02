%Este programa calcula el mayor de dos numeros introducidos por el usuario

clc                                             %Limpiar el espacio de trabajo
num1=input('Introduzca el primer numero:   ');  %Leer el primer numero
num2=input('Introduzca el segundo numero:  ');  %Leer el segundo numero
if num1 > num2                                  %Si (el primero es mayor que el segundo) entonces
    fprintf('El mayor es  %d',num1);            %imprimir "El mayor es el primero" 
else                                            %Si No
    fprintf('El mayor es  %d',num2);            %imprimir "El mayor es el segundo" 
end
