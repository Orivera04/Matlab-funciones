%Michael Antonio Gonzalez Gunera
%Jose Rafael Fuentes Carballo

clc;
fprintf('Pausas para descompresion\n');
profundidad=input('Provea la profundidad a la que se inmersara en pies\n');
switch profundidad
    case 70
        tiempo=input('Provea el tiempo durante el cual se sumergira\n');
        switch tiempo
            case 100
                fprintf('A 20 pies su tiempo de descompresion sera de 0 minutos\n');
                fprintf('A 10 pies su tiempo de descompresion sera de 33 minutos\n');
            case 110
                fprintf('A 20 pies su tiempo de descompresion sera de 2 minutos\n');
                fprintf('A 10 pies su tiempo de descompresion sera de 41 minutos\n');
            case 120
                fprintf('A 20 pies su tiempo de descompresion sera de 4 minutos\n');
                fprintf('A 10 pies su tiempo de descompresion sera de 47 minutos\n');
            case 130
                fprintf('A 20 pies su tiempo de descompresion sera de 6 minutos\n');
                fprintf('A 10 pies su tiempo de descompresion sera de 52 minutos\n');
            otherwise
                fprintf('Este valor no figura en la base de datos');
        end;
    case 80
        tiempo=input('Provea el tiempo durante el cual se simergira\n');
        switch tiempo
            case 100
                fprintf('A 20 pies su tiempo de descompresion sera de 11 minutos\n');
                fprintf('A 10 pies su tiempo de descompresion sera de 46 minutos\n');
            case 110
                fprintf('A 20 pies su tiempo de descompresion sera de 13 minutos\n');
                fprintf('A 10 pies su tiempo de descompresion sera de 53 minutos\n');
            case 120
                fprintf('A 20 pies su tiempo de descompresion sera de 17 minutos\n');
                fprintf('A 10 pies su tiempo de descompresion sera de 56 minutos\n');
            case 130
                fprintf('A 20 pies su tiempo de descompresion sera de 19 minutos\n');
                fprintf('A 10 pies su tiempo de descompresion sera de 63 minutos\n');
            otherwise
                fprintf('Este valor no figura en la base de datos');
        end;
    case 90
        tiempo=input('Provea el tiempo durante el cual se simergira\n');
        switch tiempo
            case 100
                fprintf('A 20 pies su tiempo de descompresion sera de 21 minutos\n');
                fprintf('A 10 pies su tiempo de descompresion sera de 54 minutos\n');
            case 110
                fprintf('A 20 pies su tiempo de descompresion sera de 24 minutos\n');
                fprintf('A 10 pies su tiempo de descompresion sera de 61 minutos\n');
            case 120
                fprintf('A 20 pies su tiempo de descompresion sera de 32 minutos\n');
                fprintf('A 10 pies su tiempo de descompresion sera de 68 minutos\n');
            case 130
                fprintf('A 20 pies su tiempo de descompresion sera de 36 minutos\n');
                fprintf('A 10 pies su tiempo de descompresion sera de 74 minutos\n');
            otherwise
                fprintf('Este valor no figura en la base de datos');
        end;
end;
fprintf('ADVERTENCIA: NO SE SUMERJA SIN LOS CONICIMIENTOS APROPIADOS');
end