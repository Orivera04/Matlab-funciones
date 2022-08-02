function colorpoly = colorp(x,y,C)
%Función para colorear un polígono
%x: abscisas de los vértices; y: ordenadas de los vértices.
%Deben darse en froma ordenada; por ejemplo en sentido horario.
%C:color de llenado
colorpoly=fill(x,y,C);
