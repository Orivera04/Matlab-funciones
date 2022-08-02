echo on
% Arquivo: cap2_exercicio_06.m
% CAPITULO 2 - Solucao do Exercicio 6
% Criar superficie X * cos(2*Y) entre [-pi,pi]
x = -pi:0.2:pi;
y = -pi:0.2:pi;
[X,Y] = meshgrid(x,y);
Z = X .* cos(2*Y);
subplot(1,3,1)
surf(Z)
title('Original')
subplot(1,3,2)
surf(Z)
title('Camera Reposicionada')
subplot(1,3,3)
surf(Z)
title('Iluminaçao')
