% mz = ondas(a,b,c,d)
% Desenha superficie dada por
% f(x,y) = a*cos(b*x)+c*sin(d*y);
function mz=ondas(a,b,c,d)
[mx,my]=meshgrid(-pi:0.1:pi,-pi:0.1:pi);
mz=a*cos(b*mx)-c*sin(d*my);
surf(mx,my,mz)
title(['f(x,y) = (' num2str(a) ')* cos(' ...
    num2str(b) '*x) + (' num2str(c) ')* sin('...
    num2str(d) '*y)'])   
