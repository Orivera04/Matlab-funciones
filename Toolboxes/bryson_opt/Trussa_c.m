function [c,ceq]=trussa_c(p,W)
% Subroutine for Pb. 1.3.17;                  10/96, 3/22/02
%
th=p(1); z=p(2); s=sin(th); co=cos(th); c=[]; 
if z>co^2, ceq=W*z^2-s*co^2;  else, ceq=W*z-s*(2-z/co^2); end

