%Maria Lucila Campos
%Maria Eugenia Aguirre

clc;
fprintf('   pausas para la descompresion\n ');
pf=input('De la profundidad en pies:'); 
if (pf<70)|(pf>90);
    fprintf('Solo se trabaja con rangos de 70,80,90 pies\n');
    break
end
tim=input('De el tiempo de duracion de la inmersion en minutos: ');
if(tim<100)|(tim>130);
    fprintf('Solo se trabaja con tiempos de 100 a 130 minutos\n');
    break
end
     if (pf>=70)&(pf<80)
     if (tim>=100)&(tim<110)
         a20=0;
         a10=33;
     elseif (tim>=110)&(tim<120)
             a20=2;
             a10=41;
     elseif (tim>=120)&(tim<130)
             a20=4;
             a10=47;
         else
             a20=6;
             a10=52;
         end
     end
 end
 if (pf>=80)&(pf<90)
     if (tim>=100)&(tim<110)
         a20=11;
         a10=46;
     elseif (tim>=110)&(tim<120)
             a20=13;
             a10=53;    
     elseif (tim>=120)&(tim<130)
             a20=17;
             a10=56;
     else
           a20=19;
             a10=63;
     end
 end

 if (pf>=90)
     if (tim>=100)&(tim<110)
         a20=21;
         a10=54;
     elseif (tim>=110)&(tim<120)
             a20=24;
             a10=61;
           elseif (tim>=120)&(tim<130)
             a20=32;
             a10=68;
         else 
             a20=36;
             a10=74;
         end
     end
     fprintf('\n');
 fprintf('Para una inmersion a  %d durante %d se requiere las siguientes pausa\n',pf,tim);
 fprintf('%d minutos a 20 pies\n',a20);
 fprintf('%d minutos a 10 pies\n',a10);
 disp('ADVERTENCIA: NO SE SUMERJA SIN LOS CONOCIMIENTOS APROPIADOS');
end

     
 