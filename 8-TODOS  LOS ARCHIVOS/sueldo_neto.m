%Este programa calcula el salario neto de una persona 
%a la que se le descuenta la prima de un seguro cuyo 
%monto es $9.75, si es soltera, $16.25, si es casada y 
%sin hijos y $24.50, si es casada y con hijos. Se debe 
%introducir el salario de la persona.
% 
clc;
estatus = input('Introduzca su estatus: 1,soltero.2,casado sin.3 casado con hijos \n');
if (estatus~=1 & estatus~=2 & estatus~=3)
    fprintf('El estatus solo puede ser 1, 2, 3. Intentelo de nuevo.\n')
else
   pago = input('Introduzca el pago (pago > 30)')
  if pago <= 30
     fprintf('El pago debe ser mayor que 30. Intentelo de nuevo')
  else      
      if estatus == 1
        neto = pago - 9.75
      elseif estatus == 2
        neto = pago - 16.25
      elseif estatus == 3
        neto = pago - 24.50
      else
       fprintf('El neto es:  $ %f4.2  ',neto);
      end
  end  
end

   

    
         
         
        