% CAPITULO 2 - Geracao de interface grafica
% cap2_exercicio_07_3: versao 3
function cap2_exercicio_07_3 ()
arquivo='cap2_dados1.txt';
n = 1;
m=dlmread(arquivo);
% Separacao dos dados
x=m(:,1)';
y=m(:,2)';
% Exibicao dos pontos
plot(x,y,'*')
% Calculo do a*x + b que aproxima os pontos
coef=polyfit(x,y,n);
% Calculo do valor do polinomio
yp=polyval(coef,x);
% Exibicao dos pontos e da reta de aproximacao
plot(x,y,'*',x,yp)
title(['Aproximacao por polinomio de grau ' num2str(n)])


