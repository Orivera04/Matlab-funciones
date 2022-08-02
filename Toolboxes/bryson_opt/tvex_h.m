function yp=tvex_h(t,y)
% Subroutine for tvex1; y=[x la]'; u=-la; 8/18/02
%
yp=[-t -1; 0 t]*y;
