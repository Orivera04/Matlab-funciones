% CAPITULO 2 - 2.9. Geracao de interface grafica
% cap2_exercicio_07_2(x,y): versao 2
function cap2_exercicio_07_2 (x,y)
% Solicita grau do polinomio:
dado = inputdlg('Grau do Polinomio: ','Exemplo Item 2.9');
n=str2num(dado{1}); % Extrai o dado do cell array e converte
% Calculo dos coeficientes do polinomio
coef=polyfit(x,y,n);
% Calculo do valor do polinomio
yp=polyval(coef,x);
% Exibicao dos pontos e da reta de aproximacao
plot(x,y,'*',x,yp)
title(['Aproximacao por polinomio de grau ' num2str(n)])