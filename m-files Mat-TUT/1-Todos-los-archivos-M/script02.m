% Este script calcula el �rea de un c�rculo
% Se pide al usuario el radio

% Se calcula el �rea en base al radio.
fprintf('Nota: las unidades se dan en  pulgadas.\n')
radio = input('Por favor introduzca el radio: ');
area = pi * (radio^2);
 
% Imprimir el radio dando un formato
fprintf('Para una circunferencia de radio %.2f pulgadas,\n',radio)

%Imprimir el �rea dando un formato
fprintf('el �rea es %.2f pulgadas cuadradas\n',area)
