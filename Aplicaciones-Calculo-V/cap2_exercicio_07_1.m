% CAPITULO 2 - 2.9. Geracao de interface grafica
% cap2_exercicio_07_1(x,y): versao 1
function cap2_exercicio_07_1 (x,y)
% Solicita grau do polinomio:
n = input('Grau do Polinomio: ');
% Calculo dos coeficientes do polinomio
coef=polyfit(x,y,n);
% Calculo do valor do polinomio
yp=polyval(coef,x);
% Exibicao dos pontos e da reta de aproximacao
plot(x,y,'*',x,yp)
title(['Aproximacao por polinomio de grau ' num2str(n)])