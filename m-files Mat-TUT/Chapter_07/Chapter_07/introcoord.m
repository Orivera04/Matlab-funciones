function [x, y] = introcoord(extremo);
% introcoord lee y retorna el extremo especificado 
% de un segmento de recta
% Formato: introcoord(extremo) donde extremo es: 'primer'
% o 'segundo'

% 
prompt = sprintf('Introduzca la coordenada x del %s punto: ', extremo);
x = input(prompt);
 
prompt = sprintf('Introduzca la coordenada y del %s punto: ', extremo);

y = input(prompt);
end
