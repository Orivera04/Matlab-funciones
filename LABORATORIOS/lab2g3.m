%Maria Elena Gonzalez
%Rafael Guevara

clc;
fprintf('este programa le ofrece el sig. menu: \n');
fprintf(' 1 70pies\n');
fprintf(' 2 80pies\n');
fprintf(' 3 90pies\n');
pro=input('De una opcion: ');
fprintf('esta opcion le ofrece el sig. menu: \n');
fprintf(' 1 100min\n');
fprintf(' 2 110min\n');
fprintf(' 3 120min\n');
fprintf(' 4 130min\n');
t=input('de una opcion: ');
switch pro
    case 1
        switch t
            case 1
                fprintf('para una inmercion a 70 pies, duracion 100 min. se requieren las sig. pautas de descomprecion:\n');
                fprintf(' 0 min. a 20 pies\n 33 min a 10 pies\n');
                fprintf('ADVERTEBNCIA: NO SE SUMERJA SIN LOS CONOCIMIENTOS APROPIADOS');
            case 2
                fprintf('para una inmercion a 70 pies, duracion 110 min. se requieren las sig. pautas de descomprecion:\n');
                fprintf(' 2 min. a 20 pies\n 41 min a 10 pies\n');
                fprintf('ADVERTEBNCIA: NO SE SUMERJA SIN LOS CONOCIMIENTOS APROPIADOS'); 
            case 3
                fprintf('para una inmercion a 70 pies, duracion 120 min. se requieren las sig. pautas de descomprecion:\n');
                fprintf(' 4 min. a 20 pies\n 47 min a 10 pies\n');
                fprintf('ADVERTEBNCIA: NO SE SUMERJA SIN LOS CONOCIMIENTOS APROPIADOS');
            case 4
                fprintf('para una inmercion a 70 pies, duracion 130 min. se requieren las sig. pautas de descomprecion:\n');
                fprintf(' 6 min. a 20 pies\n 52 min a 10 pies\n');
                fprintf('ADVERTEBNCIA: NO SE SUMERJA SIN LOS CONOCIMIENTOS APROPIADOS');
            otherwise
                fprintf('tiempo fuera de rango');
        end;   
    case 2
        switch t
            case 1
                fprintf('para una inmercion a 80 pies, duracion 100 min. se requieren las sig. pautas de descomprecion:\n');
                fprintf(' 11 min. a 20 pies\n 46 min a 10 pies\n');
                fprintf('ADVERTEBNCIA: NO SE SUMERJA SIN LOS CONOCIMIENTOS APROPIADOS');
            case 2
                fprintf('para una inmercion a 80 pies, duracion 110 min. se requieren las sig. pautas de descomprecion:\n');
                fprintf(' 13 min. a 20 pies\n 53 min a 10 pies\n');
                fprintf('ADVERTEBNCIA: NO SE SUMERJA SIN LOS CONOCIMIENTOS APROPIADOS'); 
            case 3
                fprintf('para una inmercion a 80 pies, duracion 120 min. se requieren las sig. pautas de descomprecion:\n');
                fprintf(' 17 min. a 20 pies\n 56 min a 10 pies\n');
                fprintf('ADVERTEBNCIA: NO SE SUMERJA SIN LOS CONOCIMIENTOS APROPIADOS');
            case 4
                fprintf('para una inmercion a 80 pies, duracion 130 min. se requieren las sig. pautas de descomprecion:\n');
                fprintf(' 19 min. a 20 pies\n 63 min a 10 pies\n');
                fprintf('ADVERTEBNCIA: NO SE SUMERJA SIN LOS CONOCIMIENTOS APROPIADOS');
            otherwise
                fprintf('tiempo fuera de rango');
        end;
     case 3
        switch t
            case 1
                fprintf('para una inmercion a 90 pies, duracion 100 min. se requieren las sig. pautas de descomprecion:\n');
                fprintf(' 21 min. a 20 pies\n 54 min a 10 pies\n');
                fprintf('ADVERTEBNCIA: NO SE SUMERJA SIN LOS CONOCIMIENTOS APROPIADOS');
            case 2
                fprintf('para una inmercion a 90 pies, duracion 110 min. se requieren las sig. pautas de descomprecion:\n');
                fprintf(' 24 min. a 20 pies\n 61 min a 10 pies\n');
                fprintf('ADVERTEBNCIA: NO SE SUMERJA SIN LOS CONOCIMIENTOS APROPIADOS'); 
            case 3
                fprintf('para una inmercion a 90 pies, duracion 120 min. se requieren las sig. pautas de descomprecion:\n');
                fprintf(' 32 min. a 20 pies\n 68 min a 10 pies\n');
                fprintf('ADVERTEBNCIA: NO SE SUMERJA SIN LOS CONOCIMIENTOS APROPIADOS');
            case 4
                fprintf('para una inmercion a 90 pies, duracion 130 min. se requieren las sig. pautas de descomprecion:\n');
                fprintf(' 36 min. a 20 pies\n 74 min a 10 pies\n');
                fprintf('ADVERTEBNCIA: NO SE SUMERJA SIN LOS CONOCIMIENTOS APROPIADOS');
            otherwise
                fprintf('tiempo fuera de rango'); 
        end;
end;
end;