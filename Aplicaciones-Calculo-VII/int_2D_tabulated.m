%
% A double integration of the tabulated data.
% f(x,y) must be genarated in terms of meshgrid
% Integral computes by approximation of the integral of f(x,y) via the trapezoidal method.
% Firstly, an integration loop within inner integral over X is
% performed obtaining the function of area A(y). Secondly, outer loop
% integration is performed for A(y) over y limits
%
% Example: 
% Q = dblquad(inline('y*sin(x)+x*cos(y)'), pi, 2*pi, 0, pi);
% Q = -9.8696
% [X,Y] = meshgrid(pi:pi/100:2*pi, 0:pi/100:pi );
% Z=Y.*sin(X)+X.*cos(Y);
% int_2D_tabulated(X,Y, Z )
% ans = -9.8688
   


function V = int_2D_tabulated(X, Y, Z )
         V = trapz( Y(:,1), (trapz(X(1,:),Z, 2)) );
return


