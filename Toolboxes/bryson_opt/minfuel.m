function [f,t,s]=minfuel(p,xf,thf,tf)     
% Subroutine for Pb. 3.3.19, min fuel holding path, s=[th thdot x y]'; 
% u=tan(sg); sg=bank angle; (x,y) in V^2/g, time in V/g; 2/98, 6/20/98
%	
s0=[0 p(2) 0 0]'; optn=odeset('reltol',1e-4);
[t,s]=ode23('minfuela',[0 tf],s0,optn,p); N=length(t);
f=[s(N,1)-thf s(N,3)-xf];

