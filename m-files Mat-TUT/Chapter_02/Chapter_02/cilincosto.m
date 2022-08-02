function costoc = cilincosto(radio, altura, costo_unidad)
% cilincosto calcula el costo de construir un cilindro
% cerrado
% Formato de llamada: cilincosto(radio, altura, costo_unidad)
% Retorna el costo total
 
% El radio y la altura se dan en pies
% El costo_unidad est� dado en c�rdobas por pie cuadrado.
 
% Calcula el �rea en pies cuadrados
area_total = 2 * pi * radio * altura + 2 * pi * radio ^ 2;
  
% Calcula el costo total
costoc = area_total * costo_unidad;
end
