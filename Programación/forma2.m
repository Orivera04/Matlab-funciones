% Ejercicio de laboratorio 2
% Los buzos con equipo autónomo deben realizar pausas para descompresión si se 
% sumergen por periodos que exceden ciertos límites. La siguiente tabla muestra 
% las pausas para descompresión en inmersión a 70, 80 y 90 pies y los tiempos de 
% descompresión requeridos.
% 
% Pausas para Descompresión
% ( Tiempos en minutos )
% Profundidad     Tiempo en el fondo	    A 20 pies	    A 10 pies
%                   ( en minutos )
% -------------------------------------------------------------------                  
% 70 pies	            100                 0               33
% 	                    110                 2               41
% 	                    120                 4               47
%                     	130                 6               52
% -------------------------------------------------------------------
% 80 pies	            100	                11	            46
%                     	110	                13	            53
% 	                    120	                17	            56
%                     	130             	19	            63
% -------------------------------------------------------------------
% 90 pies	            100             	21	            54
%                     	110	                24	            61
%                     	120	                32	            68
%                     	130	                36	            74
% -------------------------------------------------------------------
% Los datos de entrada contienen la profundidad (en pies) y la duración (en 
% minutos) de la inmersión. Determínese los tiempos de descompresión apropiados 
% e imprímalos. Además imprima al final un mensaje de advertencia: "ADVERTENCIA: 
% NO SE SUMERJA SIN LOS CONOCIMIENTOS APROPIADOS".

clc;
prof=input('Cual es la profundidad de inmersion (70,80 o 90 pies):  >>');
durac=input('Cual es la duracion de la inmersion (100,110,120 o 130 minutos: >>');
min10=0;
min20=0;
switch prof
    case 70
        switch durac
            case 100
                min20=0;
                min10=33;        
            case 110
                min20=2;
                min10=41;
            case 120
                 min20=4;
                 min10=47;
            case 130
                min20=6;
                min10=52;
        end
    case 80
        switch durac
            case 100
                min20=11;
                min10=46;
            case 110
                min20=13;
                min10=53;
            case 120
                min20=17;
                min10=56;
            case 130
                min20=19;
                min10=63; 
        end
    case 90
        switch durac
            case 100
                min20=21;
                min10=54;
            case 110
                min20=24;
                min10=51;
            case 120
                min20=32;
                min10=68;
            case 130
                min20=36;
                min10=74;
        end
end        
fprintf('\nPara una inmersion a %d pies durante %d minutos se requieren las\n',prof,durac);
fprintf('siguientes pausas de descompresion:\n\n');
fprintf('%d minutos a 20 pies\n',min20);
fprintf('%d minutos a 10 pies\n\n',min10);
fprintf('ADVERTENCIA: NO SE SUMERJA SIN LOS CONOCIMIENTOS APROPIADOS');