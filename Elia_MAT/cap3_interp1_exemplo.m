% cap3_interp1_exemplo ()
echo on
% Pontos no plano
x=1:10;
y=rand(1,10);
% Pontos de interpolacao
xi=linspace(1,10,50);
% Curva de interpolacao
yi=interp1(x,y,xi,'cubic');
% Visualizacao dos resultados
plot(x,y,':',xi,yi,'r')
legend('Pontos','Interpolacao Cubica',0)
