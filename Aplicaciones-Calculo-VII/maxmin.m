%Programa para determinar máximos, mínimos,monotonía y concavidad
% de una función de una variable.

%Introducir la función a estudiar.
clc;
syms x;
disp('función que se va a estudiar')
f = 2*x^3-3*x^2-12*x +7
fprima = diff(f);
fbiprima = diff(fprima);
deltax= 0.5;
pc1e = solve(fprima);
pc2e = solve(fbiprima);
pc1 = double(pc1e(1));
pc2 = double(pc1e(2));
pcon= double(pc2e);
pto_inflex=pcon;
disp('Puntos críticos de 1a. especie');
pc1,pc2
disp('Puntos críticos de 2a. especie');
pto_inflex
disp('Valor de f en pto_inflex');
f_inflex=subs(f,x,pcon)
sust1= subs(fbiprima,x,pc1e(1));
sust2= subs(fbiprima,x,pc1e(2));
sust3= subs(f,x,pc2e);
sust4= subs(f,x,pc1e(1));
sust5= subs(f,x,pc1e(2));
val1= double(subs(fprima,x,pc1-deltax));
val2= double(subs(fprima,x,pc1+deltax));
val3= double(subs(fprima,x,pc2-deltax));
val4= double(subs(fprima,x,pc2+deltax));
if double(sust1) > 0
    fprintf('%f es un punto de mínimo\n',pc1);
elseif double(sust1)<0
    fprint('%f es un punto de máximo\n',pc1);
else
    disp('El criterio no decide,usar otro criterio')
end

if double(sust2)  < 0
    fprintf('%f es un punto de máximo\n\n',pc2);
elseif double(sust2) < 0
    fprintf('%f es un punto de mínimo\n',pc2);
else
    disp('El criterio no decide,usar otro criterio')
end
fmax=subs(f,x,pc1);
fmin=subs(f,x,pc2);
disp('');
disp('Los máximos y mínimos de f son: ');
fmax,fmin
if (val1<0 & val2>0) 
    fprintf('\n f es cóncava hacia abajo en (-2,%f)',pcon )
else
    fprintf('\n no hay cambio de concavidad en (-2,%f)',pcon)
end

if (val3>0 & val4<0) 
    fprintf('\n f es cóncava hacia arriba en (%f, 3)',pcon)
else
   fprintf('\n no hay cambio de concavidad en (%f, 3)',pcon)
   
end
 fprintf('\n')
ezplot(f,[-2,3])
grid on;
hold on;
plot(pc1,fmax,'ro');
plot(pc2,fmin,'go');
plot(pcon,f_inflex,'co');

text(-1,16,'Máximo');
text(2,-15,'Mínimo');
text(0.6,1,'Punto de inflexión');
text(-1.5,4,'Cóncava hacia abajo');
text(1.2,-4,'Cóncava hacia arriba')
hold off
    