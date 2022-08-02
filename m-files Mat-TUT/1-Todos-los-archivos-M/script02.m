% Este script calcula el área de un círculo
% Se pide al usuario el radio

% Se calcula el área en base al radio.
fprintf('Nota: las unidades se dan en  pulgadas.\n')
radio = input('Por favor introduzca el radio: ');
area = pi * (radio^2);
 
% Imprimir el radio dando un formato
fprintf('Para una circunferencia de radio %.2f pulgadas,\n',radio)

%Imprimir el área dando un formato
fprintf('el área es %.2f pulgadas cuadradas\n',area)
