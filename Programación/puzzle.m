clc;
fprintf('Este es un pequeño juego en donde Ud podra resolver un rompecabezas\n');
fprintf('El rompecabezas original es el que se muestra aqui.\n\n');
matriz=[0 1 2;3 4 5;6 7 8];
imprpuzzle(matriz);
opc=input('Digite R para revolver las piezas del rompecabeza o S para salir: >> ','s');
switch opc
    case {'R','r'}
        resolver(matriz);
    case {'S','s'}
        fprintf('\nEl programa ha finalizado, presione una tecla para continuar...\n');
        pause;
        clc;
    otherwise
        fprintf('\n');
        puzzle;
end