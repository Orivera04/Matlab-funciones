function f=zrmpt_f(p)		                                     
% Subroutine for Pb. 4.3.12; min time to cross a river with a
% parabolic current; uc=1-y^2; s=(x,y)         12/96, 9/13/98
%
global th0; th0=p(1); tf=p(2); s0=[0 -1]'; 
opton=odeset('reltol',1e-4);
[t,s]=ode23('zrmpar',[0 tf],s0,opton);
N=length(t); xf=s(N,1); yf=s(N,2); f=[xf yf-1];


