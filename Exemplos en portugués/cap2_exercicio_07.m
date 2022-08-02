echo on
% Arquivo: cap2_exercicio_07
% CAPITULO 2 - Solucao do Exercicio 7
% Leitura e gravacao de arquivo ASCII

% Solucao do item I
% Leitura do arquivo 'cap2_dados1.txt' com
% a funcao dlmread.
%%
m=dlmread('cap2_dados1.txt');
% Separacao dos dados
x=m(:,1)';
y=m(:,2)';
%%
% Exibicao dos pontos
plot(x,y,'*')

% Solucao do item II
% Calculo do a*x + b que aproxima os pontos
coef=polyfit(x,y,1);
% Calculo do valor do polinomio
yp=polyval(coef,x);
% Exibicao dos pontos e da reta de aproximacao
plot(x,y,'*',x,yp)

% Solucao do item III
% Montagem da matriz m: m concatenada com
% o vetor yp transposto
m=[m yp'];
% gravacao do arquivo de saida
% 'cap2_saida1.txt' contendo a matriz m
dlmwrite('cap2_saida1.txt',m);
