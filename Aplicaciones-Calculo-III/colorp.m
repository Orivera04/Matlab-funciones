function colorpoly = colorp(x,y,C)
%Funci�n para colorear un pol�gono
%x: abscisas de los v�rtices; y: ordenadas de los v�rtices.
%Deben darse en froma ordenada; por ejemplo en sentido horario.
%C:color de llenado
colorpoly=fill(x,y,C);
