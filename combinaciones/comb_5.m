%   Programa para generar combinaciones N-arias de un conjunto C
function a = combina_5(c)
p=1;
%   Abrir N ciclos for anidados:
for k1=   1 : c - 4
for k2=k1+1 : c - 3
for k3=k2+1 : c - 2
for k4=k3+1 : c - 1
for k5=k4+1 : c - 0
%   Instrucciones dentro del ciclo anidado:
a(p,1)=k1
a(p,2)=k2
a(p,3)=k3
a(p,4)=k4
a(p,5)=k5
p=p+1;
%   Cerrar los N ciclos for anidados
end
end
end
end
end
a