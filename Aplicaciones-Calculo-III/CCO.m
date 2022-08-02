function CCO(h,color)
%Cambia_color_objeto(h,color)
%Cambia el color  a un objcto.

% Entradas
%         h      - Es una referencia del objeto gráfico.
%         Color  - color del objeto - Defecto: black
%                  Los colors son: 'yellow', 'magenta', 'cyan', 'red', 'green', 'blue', and 'white'
% Salida  objeto con color cambiado.
try
    set(h,'EdgeColor',color)
    set(h,'FaceColor',color)
catch
    set(h,'Color',color)
end    