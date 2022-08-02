function [f,t,s]=vdpctdy(p)       
% Subroutine for Pb. 3.3.12; VDP for max range with gravity, thrust, drag,
% and spec. yf using fdbk ga=ga(V;p), p=(Vf,gaf); s=[V y x]'; V in sqrt(gl),
% a in g, t in sqrt(l/g), (x,y) in l;                              6/15/98
%
global p a tf yfd ; Vf=p(1); s0=[0 0 0]'; optn1=odeset('reltol',1e-4);
[t,s]=ode23('vdptdode',[0 tf],s0,optn1); N=length(t); Vfo=s(N,1);
yf=s(N,2); f=[Vf-Vfo; yf-yfd];
	
	
