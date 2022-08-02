% echo on
% cap5_hg_exemplo
x=0:0.3:2*pi; % Cria o grafico
plot(x,x+sin(x))
% echo on
h=gcf;  % Obtem o handle da figura corrente
hline=findobj(h,'Type','line') % Localiza objeto tipo 'line'
get(hline)  % Lista de propriedades
get(hline,'LineStyle') % Consulta propriedade LineStyle
pause
set(hline,'LineStyle','>') % Modifica
