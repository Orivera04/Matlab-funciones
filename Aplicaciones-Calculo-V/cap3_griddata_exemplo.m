% cap3_griddata_exemplo ()
echo on
% Pontos no espaco
[X,Y]=meshgrid([1:5],[1:5]);
Z=randn(5);
% Pontos de interpolacao
[XI,YI]=meshgrid([1:0.2:5],[1:0.2:5]);
% Superficie de interpolacao
ZI=griddata(X,Y,Z,XI,YI,'cubic');
% Visualizacao dos resultados
subplot(1,2,1)
surf(X,Y,Z)
title('Pontos do espaco')
subplot(1,2,2)
surf(XI,YI,ZI)
title('Superfice interpoladora')
