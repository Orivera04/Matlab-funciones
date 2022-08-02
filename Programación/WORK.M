%COMPLETO
clc
n=0;
while n~=5,
   n=menu('FUNCIONES DE MATLAB','Funciones Trigonométricas','Números Complejos','Funciones Polinómicas','Raices','SALIR');
   if n==1
      fun_th
   end
   if n==2
      fun_nc
   end
   %************************************
   if n==3
      m=0;
      while m~=3,
         m=menu('FUNCIONES POLINOMICAS','Ejemplos','Practica','Volver');
         if m==1
            fun_pol
         end%fin si
         if m==2
            fun_polp
         end%fin si
      end%fin while
   end%fin si
   %************************************
   if n==4
      l=0;
      while l~=3,
         l=menu('RAICES DE UN POLINOMIO','Ejemplos','Practica','Volver');
         if l==1
            raices
         end%fin si
         if l==2
            raices_p
         end%fin si
      end%fin while
   end%fin si

end%fin while