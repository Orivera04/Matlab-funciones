% cap3_interp2_exemplo ()
echo on
% Pontos no espaco
[X,Y]=meshgrid([1:5],[1:5]);
Z=cos(pi+randn(5));
% Pontos de interpolacao
[XI,YI]=meshgrid([1:0.2:5],[1:0.2:5]);
% Superficie de interpolacao
ZI1=griddata(X,Y,Z,XI,YI,'cubic');
ZI2=interp2(X,Y,Z,XI,YI,'cubic');
% Visualizacao dos resultados
subplot(1,2,1)
plot3(X,Y,Z,'o')
hold
surf(XI,YI,ZI1)
title('Superfice GRIDDATA')
subplot(1,2,2)
plot3(X,Y,Z,'o')
hold
surf(XI,YI,ZI2)
title('Superfice INTERP2')
