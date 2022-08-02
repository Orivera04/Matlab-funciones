function yd=ipez(t,y,flag,ts,ep,umax)
% Subroutine for ipz;                  12/6/01
%
th=y(1); q=y(2); v=y(4); s=sin(th); c=cos(th); 
if               t<=ts(1), u= umax;
elseif t>ts(1) & t<=ts(2), u=-umax;
elseif t>ts(2) & t<=ts(3), u= umax;   
elseif t>ts(3) & t<=ts(4), u=-umax; 
elseif t>ts(4) & t<=ts(5), u= umax; 
elseif t>ts(5) & t<=ts(6), u=-umax;
end
A=[1 ep*c; c 1]; b=[u+ep*s*q^2; -s]; vqd=A\b; 
yd=[q vqd(2) v vqd(1)]';

