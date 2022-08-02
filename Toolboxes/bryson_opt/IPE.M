function yd=ipe(t,y,flag,ep,umax)
% Subroutine for ip;               4/98, 12/6/01
%
th=y(1); q=y(2); v=y(4); s=sin(th); c=cos(th);
A=[1 ep*c; c 1]; b=[umax+ep*s*q^2; -s]; vqd=A\b; 
yd=[q; vqd(2); v; vqd(1)];

