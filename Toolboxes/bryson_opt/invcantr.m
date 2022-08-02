function f=invcantr(p,W)
% Subroutine for Pb.1.2.16; min weight inverted cantilever truss,
% analytical solution;  			               1/92, 10/96, 5/26/98
%
th=p(1); z=p(2); s=sin(th); c=cos(th);
if z<=1, h=1-z/2; dh=-1/2; elseif z>1, h=1/(2*z); dh=-1/(2*z^2); end
f(1)=W*z-h*s;
f(2)=(-W*z^2*c^2+z*s^3)*(W-dh*s)-h*(c*s)^2;