% yi = exercicios_propostos_06 (x,y)
% Entradas
%   x: valores no eixo X
%   y: valores no eixo Y contendo NaN para indicar ausencia 
%      de informacao
% Saida
%   yi: valores no eixo Y contendo valores interpolados por 
%   spline nas posicoes originalmente indicadas por NaN
function yi = exercicios_propostos_06(x,y)
% Vetor de saida yi recebe todos os valores de y
yi = y;
% Obtem vetor de indices de elementos de y diferentes de NaN
ind = find(~isnan(y));
% Cria vetores auxiliares, sem os valores NaN
xaux=x(ind);
yaux=y(ind);
% Calcula spline
pp=spline(xaux,yaux);
% Calcula valores interpolados para as posicoes NaN
ind=find(isnan(y));
yi(ind)=ppval(pp,x(ind));
% Calcula curva spline
xx=linspace(min(x),max(x),200);
yy=ppval(pp,xx);
% Exibe grafico
plot(xx,yy,x,y,'+',x(ind),yi(ind),'o')
legend('Curva Spline','Pontos originais','Pontos Interpolados',0)
title(['Serie com ' num2str(length(x)) ' observacoes'])
shg
