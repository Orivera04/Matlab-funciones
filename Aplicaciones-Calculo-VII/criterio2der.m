%Programa para determinar m�ximos, m�nimos,monoton�a y concavidad
% de una funci�n de una variable.

%Introducir la funci�n a estudiar.
clc;
syms x;
f = input('Funci�n a estudiar: f(x)= ');
fprima = diff(f);
fbiprima = diff(fprima);
deltax= 0.5;
pc1e = solve(fprima);
pc2e = solve(fbiprima);
pc= double(pc1e);
pinflex=double(pc2e);
disp('Puntos cr�ticos de 1a. especie');
pcr=elimigual(pc)
n=numel(pcr)
disp('Valores de f en los puntos cr�ticos')
valpc=subs(f,x,pcr);
valpc
disp('Puntos cr�ticos de 2a. especie');
pcr2e=elimigual(pinflex)  
disp('Valores de f en posibles ptos. de inflexi�n');
valinflex=subs(f,x,pcr2e)
disp('Valores de fbiprima en ptos. cr�ticos')
vecpc2d=subs(fbiprima,x,pcr)
k=0;
j=0;
for i=1:n
   
      if vecpc2d(i)<0
         k= k+1;      
           fprintf('\nHay un m�ximo local en:');
           fprintf('\nx = %f',pcr(i));
           fprintf('\nf(x) = %f',valpc(i)); 
           fprintf('\n')
         x_demin = vecpc2d(i);
    elseif vecpc2d(i)>0
             j= j+1;           
          fprintf('\nHay un m�nimo local en:');
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



