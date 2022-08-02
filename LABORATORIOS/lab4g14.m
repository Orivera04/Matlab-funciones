clc;
%Maria Lucila Campos Navarrete y Maria Eugenia Aguirre Mendoza
cliente =1;
ntr = 0;
nrs = 0;
 while(cliente >= 0) 
     clc;
     cliente = input('De el tipo de cliente Particular(0) Empresa(1): ');
   if cliente >=0 && cliente <=1
       consumo = input('De el consumo en KWH: ');
       if cliente ==0
           if consumo >=0 && consumo<=20
               cosrec = 10 * consumo;
           elseif consumo >= 21 && consumo <= 50
               cosrec = 15 * consumo;
           elseif consumo >= 51 && consumo <= 100
               cosrec = 25 * consumo;
           elseif cosrec >100
               cosrec = 30 * consumo;
           end
       elseif cliente==1
           if consumo >=0 && consumo<=20
               cosrec = 10 * consumo;
           elseif consumo >= 21 && consumo <= 50
               cosrec = 20 * consumo;
           elseif consumo >= 51 && consumo <= 100
               cosrec = 30 * consumo;
           elseif cosrec >100
               cosrec = 50 * consumo;
           end
       end
   end
     if cosrec >1000
         nrs = nrs + 1;
     end
     ntr = ntr + 1;
     fprintf('\n\nEl costo del recibo es: %d',cosrec);
 end
 fprintf('\n\nLa cantidad de recibos arriba de 1000 es: %d\n\nLa cantidad total de recibos es: %d',nrs,ntr-1);