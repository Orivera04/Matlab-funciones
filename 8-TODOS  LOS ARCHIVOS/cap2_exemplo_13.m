% CAPITULO 2 - Exemplo de funcao
% m = cap2_exemplo_13 (Arq_Entrada, Arq_Saida)
% 1. Le arquivo Arq_Entrada com dlmread
% 2. Executa as mesmas instrucoes em 'cap2_exercicio_7'
% 3. Gera arquivo Arq_Saida com dlmwrite
% 4. Retorna a matriz m e o vetor coef
function [m, coef] = cap2_exemplo_13 ( Arq_Entrada, Arq_Saida )
% Leitura do arquivo Arq_Entrada com a funcao dlmread.
m=dlmread(Arq_Entrada);
% Separacao dos dados
x=m(:,1)';
y=m(:,2)';
% Exibicao dos pontos
plot(x,y,'*')
% Calculo do a*x + b que aproxima os pontos
coef=polyfit(x,y,1);
% Calculo do valor do polinomio
yp=polyval(coef,x);
% Exibicao dos pontos e da reta de aproximacao
plot(x,y,'*',x,yp)
% Montagem da matriz m: m concatenada com
% o vetor yp transposto
m=[m yp'];
% gravacao do arquivo de saida contendo a matriz m
dlmwrite(Arq_Saida,m);