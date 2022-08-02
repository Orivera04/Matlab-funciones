%pausas para descompresion.
%Norman Altamirano Lopez 
%Sergio Gaitan Peñate

clc;
fprintf ('            ==========================================================\n');
fprintf('                                    Hecho por:\n');
fprintf ('                 *Norman Altamirano Lopez y Sergio Gaitan Peñate*\n');
fprintf ('            ==========================================================\n');
prof=input('                  cuantos pies de profundidad bajara entre 70-80-90\n');
fprintf ('\n');
tf= input('             cuanto tiempo estara en el fondo entre 100-110-120-130 minutos\n');
fprintf ('\n');
if (prof==70)&(tf==100)
    fprintf ('para una inmersion a 70 pies durante 100 minutos se requieren las siguientes pausas:\n ');
    fprintf                       ('\t0 minutos a 20 pies\n ');
    fprintf                      ('\t33 minutos a 10 pies\n ');
    fprintf ('¡ADVERTENCIA! no se sumerja sin los conocimientos apropiados' );
elseif (prof==70)&(tf==110)
    fprintf ('para una inmersion a 70 pies durante 110 minutos se requieren las siguientes pausas:\n ');
    fprintf                       ('\t2 minutos a 20 pies\n ');
    fprintf                      ('\t41 minutos a 10 pies\n ');
    fprintf ('¡ADVERTENCIA! no se sumerja sin los conocimientos apropiados' );
elseif (prof==70)&(tf==120)
    fprintf ('para una inmersion a 70 pies durante 120 minutos se requieren las siguientes pausas:\n ');
    fprintf                       ('\t4 minutos a 20 pies\n ');
    fprintf                      ('\t47 minutos a 10 pies\n ');
    fprintf ('¡ADVERTENCIA! no se sumerja sin los conocimientos apropiados' );
elseif(prof==70)&(tf==130)
    fprintf ('para una inmersion a 70 pies durante 130 minutos se requieren las siguientes pausas:\n ');
    fprintf                      ('\t6 minutos a 20 pies\n ');
    fprintf                     ('\t52 minutos a 10 pies\n ');
    fprintf ('¡ADVERTENCIA! no se sumerja sin los conocimientos apropiados' );
elseif(prof~=70)&(prof~=80)&(prof~=90)
    fprintf('                   la profundidad que ingreso no es permitida \n');
    fprintf ('\n');
    fprintf ('\n');
end
 if(prof==80)&(tf==100)
    fprintf ('para una inmersion a 80 pies durante 100 minutos se requieren las siguientes pausas:\n ');
    fprintf                    ('\t11 minutos a 20 pies\n ');
    fprintf                    ('\t46 minutos a 10 pies\n ');
    fprintf ('¡ADVERTENCIA! no se sumerja sin los conocimientos apropiados' );
elseif(prof==80)&(tf==110)
    fprintf ('para una inmersion a 80 pies durante 110 minutos se requieren las siguientes pausas:\n ');
    fprintf                    ('\t13 minutos a 20 pies\n ');
    fprintf                    ('\t53 minutos a 10 pies\n ');
    fprintf ('¡ADVERTENCIA! no se sumerja sin los conocimientos apropiados' );
    elseif(prof==80)&(tf==120)
    fprintf ('para una inmersion a 80 pies durante 120 minutos se requieren las siguientes pausas:\n ');
    fprintf                    ('\t17 minutos a 20 pies\n ');
    fprintf                    ('\t56 minutos a 10 pies\n ');
    fprintf ('¡ADVERTENCIA! no se sumerja sin los conocimientos apropiados' );
elseif(prof==80)&(tf==130)
    fprintf ('para una inmersion a 80 pies durante 130 minutos se requieren las siguientes pausas:\n ');
    fprintf                   ('\t19 minutos a 20 pies\n ');
    fprintf                   ('\t63 minutos a 10 pies\n ');
    fprintf ('¡ADVERTENCIA! no se sumerja sin los conocimientos apropiados' );
end
if(prof==90)&(tf==100)
    fprintf ('para una inmersion a 90 pies durante 100 minutos se requieren las siguientes pausas:\n ');
    fprintf                   ('\t21 minutos a 20 pies\n ');
    fprintf                   ('\t54 minutos a 10 pies\n ');
    fprintf ('¡ADVERTENCIA! no se sumerja sin los conocimientos apropiados' );
elseif(prof==90)&(tf==110)
    fprintf ('para una inmersion a 90 pies durante 110 minutos se requieren las siguientes pausas:\n ');
    fprintf                  ('\t24 minutos a 20 pies\n ');
    fprintf                  ('\t61 minutos a 10 pies\n ');
    fprintf ('¡ADVERTENCIA! no se sumerja sin los conocimientos apropiados' );
elseif(prof==90)&(tf==120)
    fprintf ('para una inmersion a 90 pies durante 120 minutos se requieren las siguientes pausas:\n ');
    fprintf                  ('\t32 minutos a 20 pies\n ');
    fprintf                  ('\t68 minutos a 10 pies\n ');
    fprintf ('¡ADVERTENCIA! no se sumerja sin los conocimientos apropiados' );
elseif(prof==90)&(tf==130)
    fprintf ('para una inmersion a 90 pies durante 130 minutos se requieren las siguientes pausas:\n ');
    fprintf                  ('\t36 minutos a 20 pies\n ');
    fprintf                  ('\t74 minutos a 10 pies\n ');
    fprintf ('¡ADVERTENCIA! no se sumerja sin los conocimientos apropiados\n');
elseif (tf~=100)&(tf~=110)&(tf~=120)&(tf~=130)
    fprintf ('                  el tiempo que estara en el fondo no es permitido\n');
end
fprintf ('\n');
fprintf ('\n');
fprintf ('                                LABORATORIO Nº 2\n');


















