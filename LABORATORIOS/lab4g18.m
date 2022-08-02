clc;
%michael gonzalez gunera
%Jose Rafael Fuentes Carballo
%grupo 18
cliente=1;
recibomayores= 0;
numeroclientes= 0;
 while(cliente>= 0) 
     clc;
     cliente= input('Que tipo de cliente es?\nDigite (0) PARA PARTICULARES (1) PARA EMPRESAS: ','s');
   if (cliente=='0') | (cliente=='1')
       consumo= input('De el consumo en KWH de su recibo: ');
       if (cliente=='0')
           if (consumo>=0) & (consumo<=20)
               cosrec= 10 * consumo;
           elseif (consumo>= 21) & (consumo <= 50)
               cosrec= 15 * consumo;
           elseif (consumo>= 51) & (consumo<= 100)
               cosrec= 25 * consumo;
           else
               cosrec= 30 * consumo;
           end    
       elseif (cliente=='1')
           if (consumo>=0) & (consumo<=20)
               cosrec= 10 * consumo;
           elseif (consumo>= 21) & (consumo <= 50)
               cosrec= 20 * consumo;
           elseif (consumo>= 51) & (consumo<= 100)
               cosrec= 30 * consumo;
           else
               cosrec= 50 * consumo;
           end
       end
   end
     if (cosrec>1000)
         recibomayores= recibomayores + 1;
     end
     numeroclientes= numeroclientes + 1;
     fprintf('\n\n El saldo total a pagar por su recibo es de: %d \n',cosrec);
     fprintf('\n Presione una tecla para continuar\n');
     pause;
 end
 fprintf('\n\n La cantidad de recibos mayores de 1000 cordobas es de: %d\n',recibomayores);
 fprintf('\nLa cantidad total de recibos ingresados al sistema es de: %d\n',numeroclientes);
end