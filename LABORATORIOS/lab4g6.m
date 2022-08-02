%Diana Lanzas Calero y Sheyla Castro Maltez, Grupo # 6
superanmil=0;
totalderecibos=0;
while 1
fprintf('Este programa le brinda el siguiente menu\n');
fprintf('De una compañia de electricidad\n');
fprintf('Seleccione la opcion (0) si es un cliente particular\n');
fprintf('Seleccione la opcion (1) si es un cliente de empresa\n');
opcion=input('Seleccione una opcion:  \n');
consumo=input('En Kwh, ¿De cuanto es su consumo?   \n');
switch opcion
    case 0
        if (consumo>=0)&(consumo<=20)
            costodelrecibo=10*consumo;
            fprintf('El costo de su recibo es de %.2f cordobas \n',costodelrecibo);
        else
            if(consumo>=21)&(consumo<=50)
                costodelrecibo=15*consumo;
                fprintf('El costo de su recibo es de %.2f cordobas \n',costodelrecibo);
            else 
                if(consumo>=51)&(consumo<=100)
                    costodelrecibo=25*consumo;
                    fprintf('El costo de su recibo es de %.2f cordobas \n',costodelrecibo);
                else
                    if(consumo>100)
                        costodelrecibo=30*consumo;
                        fprintf('El costo de su recibo es de %.2f cordobas \n',costodelrecibo);
                    end
                end
            end
        end
    case 1
        if (consumo>=0)&(consumo<=20)
            costodelrecibo=10*consumo;
            fprintf('el costo de su recibo es de %.2f cordobas\n',costodelrecibo);
        else
            if(consumo>=21)&(consumo<=50)
                costodelrecibo=20*consumo;
            else 
                if(consumo>=51)&(consumo<=100)
                    costodelrecibo=30*consumo;
                else 
                    if(consumo>100)
                        costodelrecibo=50*consumo;
                    end
                end
            end
        end
    otherwise
        if opcion>1
            fprintf('Fuera de rango,...intente de nuevo!!!!\n');
        else
            if opcion<0
                break;
            end
        end
end
if costodelrecibo>1000
    superanmil=superanmil+1;
    fprintf(' %d recibos de electricidad han superado los mil cordobas\n', superanmil);
end
totalderecibos=totalderecibos+1;
fprintf('El numero total de recibos introducidos es %d \n',totalderecibos);
fprintf('\n\n\n\n\n\n\n');
pause
end