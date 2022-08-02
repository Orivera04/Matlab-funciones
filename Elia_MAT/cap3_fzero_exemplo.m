% cap3_fzero_exemplo ()
function cap3_fzero_exemplo( )
% x1: busca a partir de 0
x1=fzero('cap3_funcao2',0);
% x2: busca a partir de 2
x2=fzero('cap3_funcao2',2);
% Visualizacao do resultado
x=0:0.1:2*pi;
plot(x,cap3_funcao2(x), ... % Funcao
     x1,0,'r*', ... % busca a partir de 0
     x2,0,'ro')     % busca a partir de 2
legend('Funcao',...
    'Busca a partir de 0','Busca a partir de 2',0) 