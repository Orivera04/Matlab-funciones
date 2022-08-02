% cap3_polyval_exemplo ( )
echo on
% Pontos (X,Y)
x=1:10;
y=[2 3 3.5 3.5 3 3 2.5 2.5 3 4];
% Polinomio de grau 3
p3=polyfit(x,y,3);
% Valores para avaliacao do polinomio
xn=linspace(1,10,20);
% Avaliacao do polinomio
yn=polyval(p3,xn);
% Visualizacao dos resultados
plot(x,y,':',xn,yn,'r')
legend('Pontos','Polinomio')