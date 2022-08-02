function f=trussa_f(p,W)
% Subroutine for Pb. 1.3.17;            10/96, 3/22/02
%
th=p(1); z=p(2); s=sin(th); c=cos(th); f=W*(c/s+s/c)+2/(z*c);


