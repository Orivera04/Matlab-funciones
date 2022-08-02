% cap3_spline_exemplo ()
echo on
% Pontos no plano
x=1:10;
y=rand(1,10);
% Calculo dos coeficientes da spline
S=spline(x,y);
% Pontos de interpolacao
xs=linspace(1,10,100);
% Calculo dos valores da spline
ys=ppval(S,xs);
% Visualizacao dos resultados
plot(x,y,':',xs,ys,'r')
legend('Pontos','Spline',0)
