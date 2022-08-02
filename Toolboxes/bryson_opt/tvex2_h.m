function yp=tvex2_h(t,y)
% Subroutine for tvex2; y=[x v lx lv]' 8/22/02
%
yp=[0 1 0 0; -1 -t 0 -1; 0 0 0 1; 0 0 -1 t]*y;
