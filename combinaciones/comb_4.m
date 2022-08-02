%Programa para generar combinaciones N-arias de un conjunto C
%Oden de las combinaciones: 4
function a = comb_4(c)
p=1;
%Abrir N ciclos for anidados: " for k_i=k_(i-1):c-(N-i) " 
for k1=1:c - 3
  for k2=k1+1 : c - 2
   for k3=k2+1 : c - 1
    for k4=k3+1 : c - 0
%Escribir las N instrucciones del ciclo anidado:" a(p,i)=ki; "
     a(p,1)=k1;
     a(p,2)=k2;
     a(p,3)=k3;
     a(p,4)=k4;
     p=p+1;
%Cerrar los N ciclos for anidados
    end
   end
  end
end
a