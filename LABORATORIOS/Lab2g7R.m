%Luz Keyling Aleman Arce
%Richard Alexander Bravo
clc;
profundidad=input('elija una profundidad de inmersion 70,80,90    ');
tiempo=input('elija un tiempo de inmersion 100,110,120,130   ');
if(profundidad==70)&(tiempo==100)
    Pies1=0;
    Pies2=33;
else if (tiempo==110)
        Pies1=2;
        Pies2=41;
else if(tiempo==120)
            Pies1=4;
            Pies2=47;
else if(tiempo==130)
                Pies1=6;
                Pies2=52;
else
                fprintf('ERROR');
            end;
        end;
    end;
end;
if(profundidad==80)&(tiempo==100)
            Pies1=11;
            Pies2=46;
        else if(tiempo==110)
                Pies1=13;
                Pies2=53;
            else if(tiempo==120)
                    Pies1=17;
                    Pies2=56;
                else if(tiempo==130)
                        Pies1=19;
                        Pies2=63;
                    else
                        fprintf('ERROR');
                    end;
                end;
            end;
        end;
     if(profundidad==90)&(tiempo==100)
                        Pies1=21;
                        Pies2=54;
                    else if(tiempo==110)
                            Pies1=24;
                            Pies2=61;
                        else if(tiempo==120)
                                Pies1=32;
                                Pies2=68;
                            else if(tiempo==130)
                                    Pies1=36;
                                    Pies2=74;
                                else
                                    fprintf('ERROR');
                                end;
                            end;
                        end;
fprintf('para una inmersion a %d pies durante %d minutos se requieren las siguientes pausas de descompresion:\n',profundidad,tiempo);
fprintf('%d minutos en 20 pies\n',Pies1);
fprintf('%d minutos en 10 pies\n',Pies2);
fprintf('ADVERTENCIA:');
fprintf('No se sumerja sin los conocimientos apropiados, no se arriesgue');
end;