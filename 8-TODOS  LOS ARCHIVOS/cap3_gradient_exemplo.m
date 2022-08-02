% cap3_gradient_exemplo ()
echo on
% Gerar superficie
[X,Y]=meshgrid(-pi:0.2:pi,-pi:0.2:pi);
Z=cos(X).*Y;
% Calculo do gradiente
% Derivadas parciais da curva
[PX,PY]=gradient(Z,0.2,0.2);
% Visualizacao dos resultados
subplot(2,1,1)
surf(Z)
title('Superficie')
subplot(2,1,2)
contour(Z)
hold
quiver(PX,PY)
title('Gradientes')
