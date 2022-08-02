% cap3_fminbnd_exemplo ()
function cap3_fminbnd_exemplo( )
% x1, fx1: minimo no intervalo [0,1.5]
[x1,fx1]=fminbnd('cap3_funcao1',0,1.5);
% x2, fx2: minimo no intervalo [1.5,3]
[x2,fx2]=fminbnd('cap3_funcao1',1.5,3);
% Visualizacao do resultado
x=0:0.1:pi;
plot(x,cap3_funcao1(x), ... % Funcao
     x1,fx1,'r*', ... % minimo entre [0,1.5]
     x2,fx2,'ro')     % minimo entre [1.5,3]
legend('Funcao',...
    'Minimo entre [0,1.5]','Minimo entre [1.5,3]',0) 