function [f,t,s]=vdpctdy(p)       
% Subroutine for Pb. 3.3.12;                          7/98, 3/26/02
%
global tf yf ; gaf=p(2); s0=[.001 0 0 -.99*pi/2]';
opt=odeset('reltol',1e-4); [t,s]=ode23('vdptdode',[0 tf],s0,opt,p);
N=length(t); f=[s(N,4)-gaf; s(N,2)-yf];
	
	
