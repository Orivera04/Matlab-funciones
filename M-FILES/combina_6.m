%   Programa para generar combinaciones N-arias de un conjunto C
%   Oden de las combinaciones: N=6
function a = combina_6(c)
p=1;
%   Abrir N ciclos for anidados:
for k1=   1 : c - 5
for k2=k1+1 : c - 4
for k3=k2+1 : c - 3
for k4=k3+1 : c - 2
for k5=k4+1 : c - 1
for k6=k5+1 : c - 0
%   Instrucciones dentro del ciclo anidado:
a(p,1)=k1;
a(p,2)=k2;
a(p,3)=k3;
a(p,4)=k4;
a(p,5)=k5;
a(p,6)=k6;
p=p+1;
%   Cerrar los N ciclos for anidados
end
end
end
end
end
end
a