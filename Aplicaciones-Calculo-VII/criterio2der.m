%Programa para determinar máximos, mínimos,monotonía y concavidad
% de una función de una variable.

%Introducir la función a estudiar.
clc;
syms x;
f = input('Función a estudiar: f(x)= ');
fprima = diff(f);
fbiprima = diff(fprima);
deltax= 0.5;
pc1e = solve(fprima);
pc2e = solve(fbiprima);
pc= double(pc1e);
pinflex=double(pc2e);
disp('Puntos críticos de 1a. especie');
pcr=elimigual(pc)
n=numel(pcr)
disp('Valores de f en los puntos críticos')
valpc=subs(f,x,pcr);
valpc
disp('Puntos críticos de 2a. especie');
pcr2e=elimigual(pinflex)  
disp('Valores de f en posibles ptos. de inflexión');
valinflex=subs(f,x,pcr2e)
disp('Valores de fbiprima en ptos. críticos')
vecpc2d=subs(fbiprima,x,pcr)
k=0;
j=0;
for i=1:n
   
      if vecpc2d(i)<0
         k= k+1;      
           fprintf('\nHay un máximo local en:');
           fprintf('\nx = %f',pcr(i));
           fprintf('\nf(x) = %f',valpc(i)); 
           fprintf('\n')
         x_demin = vecpc2d(i);
    elseif vecpc2d(i)>0
             j= j+1;           
          fprintf('\nHay un mínimo local en:');
          fprintf('\nx = %f',pcr(i));
          fprintf('\nf(x) = %f',valpc(i)); 
          fprintf('\n')
         
        x_demax = vecpc2d(i);
    else 
        fprintf('\nEl criterio de la 2a. derivada no decide en el punto:')
        fprintf('\nx = %f',pcr(i));
        fprintf('\nf(x) = %f',valpc(i)); 
        fprintf('\n')

      end
  
end
ezplot(f,[-2,2]);
grid on;
clear



