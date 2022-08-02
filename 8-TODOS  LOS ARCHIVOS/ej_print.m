%Imprimir un programa en un archivo
xx = 2*pi*(0:0.02:1);
plot(xx, sin(xx))
% Put a title on the figure.
title('Figure A: Sine Curve')
pause
% Store the graph in the file figureA.eps.
print -deps figureA
