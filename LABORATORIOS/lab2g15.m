clc;
fprintf('(Los buzos con equipo autonomo deben realizar pausas para descompresion si se sumergen\npor periodos que exceden ciertos limites.)\n\n')
fprintf('<El siguiente programa ofrece los tiempos de descompresion apropiados para profundidades\nen el rango de 70 a 90 pies y tiempos de inmersion de 100 a 130 minutos.>\n\n');
fprintf('Desea entrar al programa? \n\n ');
i=input(' 1=SI 2=NO : ');
if (i==1)|(i==2)
    if (i==2);
        fprintf('\n\tFIN DEL PROGRAMA');
        break
    end    
else 
    fprintf('\n\tSolo se aceptan los valores 1 y 2')
    break
end
p=input('\nDe la profundidad en pies: '); 
if (p<70)|(p>90);
    fprintf('Solo se trabaja con rangos de 70,80,90 pies\n');
    break
end
t=input('De el tiempo de duracion de la inmersion en minutos: ');
if(t<100)|(t>130);
    fprintf('Solo se trabaja con tiempos de 100 a 130 minutos\n');
    break
end
     if (p>=70)&(p<80)
     if (t>=100)&(t<110)
         a20=0;
         a10=33;
     elseif (t>=110)&(t<120)
             a20=2;
             a10=41;
     elseif (t>=120)&(t<130)
             a20=4;
             a10=47;
         else
             a20=6;
             a10=52;
         end
     end
 end
 if (p>=80)&(p<90)
     if (t>=100)&(t<110)
         a20=11;
         a10=46;
     elseif (t>=110)&(t<120)
             a20=13;
             a10=53;    
     elseif (t>=120)&(t<130)
             a20=17;
             a10=56;
     else
           a20=19;
             a10=63;
     end
 end

 if (p>=90)
     if (t>=100)&(t<110)
         a20=21;
         a10=54;
     elseif (t>=110)&(t<120)
             a20=24;
             a10=61;
           elseif (t>=120)&(t<130)
             a20=32;
             a10=68;
         else 
             a20=36;
             a10=74;
         end
     end
     fprintf('\n');
 fprintf('Para una inmersion a %d pies durante %d minutos se requieren las siguientes pausas de descompresion:\n\n',p,t);
 fprintf('%d minutos a 20 pies\n',a20);
 fprintf('%d minutos a 10 pies\n',a10);
 disp('ADVERTENCIA: NO SE SUMERJA SIN LOS CONOCIMIENTOS APROPIADOS');
end