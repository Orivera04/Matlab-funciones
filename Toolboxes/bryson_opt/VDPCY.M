function [f,t,s]=vdpcy(p)       
% Subroutine for Pb. 3.3.11; VDP for max range with gravity, thrust, and
% spec. yf; p=(Vf,gaf); s=[y x ga]'; V in g*tf, a in g, t in tf, (x,y)
% in  g*tf^2;                                        2/97, 1/98, 6/18/98
%
global yf; Vf=p(1); gaf=p(2); s0=[0 0 -pi/2]';
opt=odeset('reltol',1e-4); [t,s]=ode23('vdpode',[0 1],s0,opt,p);
N=length(t); f=[s(N,1)-yf; s(N,3)-gaf];
	
	
