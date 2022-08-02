% cap3_polyfit_exemplo ( )
echo on
% Pontos (X,Y)
x=1:10;
y=[2 3 3.5 3.5 3 3 2.5 2.5 3 4];
% Polinomio de grau 3
p3=polyfit(x,y,3)