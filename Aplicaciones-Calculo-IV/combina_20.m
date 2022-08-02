%   Programa para generar combinaciones N-arias de un conjunto C
%   Oden de las combinaciones: N=20
function a = combina_20(c)
p=1;
%   Abrir N ciclos for anidados:
for k1=   1 : c - 19
for k2=k1+1 : c - 18
for k3=k2+1 : c - 17
for k4=k3+1 : c - 16
for k5=k4+1 : c - 15
for k6=k5+1 : c - 14
for k7=k6+1 : c - 13
for k8=k7+1 : c - 12
for k9=k8+1 : c - 11
for k10=k9+1 : c - 10
for k11=k10+1 : c - 9
for k12=k11+1 : c - 8
for k13=k12+1 : c - 7
for k14=k13+1 : c - 6
for k15=k14+1 : c - 5
for k16=k15+1 : c - 4
for k17=k16+1 : c - 3
for k18=k17+1 : c - 2
for k19=k18+1 : c - 1
for k20=k19+1 : c - 0
%   Instrucciones dentro del ciclo anidado:
a(p,1)=k1;
a(p,2)=k2;
a(p,3)=k3;
a(p,4)=k4;
a(p,5)=k5;
a(p,6)=k6;
a(p,7)=k7;
a(p,8)=k8;
a(p,9)=k9;
a(p,10)=k10;
a(p,11)=k11;
a(p,12)=k12;
a(p,13)=k13;
a(p,14)=k14;
a(p,15)=k15;
a(p,16)=k16;
a(p,17)=k17;
a(p,18)=k18;
a(p,19)=k19;
a(p,20)=k20;
p=p+1;
%   Cerrar los N ciclos for anidados
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
a