% CAPITULO 2 - Geracao de interface grafica
% cap2_exercicio_07_4: versao 4
function cap2_exercicio_07_4 ()
% Obtem identificador da figura corrente
h=gcf;
% Identifica objeto com Tag = grau
obj=findobj(h,'Tag','grau');
% Obtem o conteudo do campo 'String'
str=get(obj','String'); 
% Converte cadeia de caracteres em numero
n=str2num(str);

% Identifica objeto com Tag = arquivo
obj=findobj(h,'Tag','arquivo');
% Obtem o conteudo do campo 'opcoes'
opcoes=get(obj,'String'); 
indice=get(obj,'Value');
arquivo=opcoes{indice};
m=dlmread(arquivo);
% Separacao dos dados
x=m(:,1)';
y=m(:,2)';
% Exibicao dos pontos
plot(x,y,'*')
% Calculo do polinomio de grau n
coef=polyfit(x,y,n);
% Calculo do valor do polinomio
yp=polyval(coef,x);
% Exibicao dos pontos e da reta de aproximacao
plot(x,y,'*',x,yp)
title(['Aproximacao por polinomio de grau ' num2str(n)])


