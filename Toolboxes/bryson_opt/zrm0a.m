function f=zrm0a(z,sf,yf,y0,tf)
% Subroutine for p2_3_10;                   6/26/02
%
th0=z(1); thf=z(2); st0=1/cos(th0); stf=1/cos(thf);
f=[tan(th0)-tan(thf)-tf; st0-stf-yf+y0+tan(thf)/sf];