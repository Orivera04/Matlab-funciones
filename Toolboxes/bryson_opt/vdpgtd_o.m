function f=vdpgtd_o(k,a,tf,t0)
% Subroutine for Pb.2.3.6; VDP for max range w. gravity, thrust,
% and drag;                                               2/3/98
%
V0=(1+a)*t0; y0=-V0*t0/2; ga0=-pi/2+k*V0; s0=[V0 ga0 0 y0]';
opt1=odeset('reltol',1e-4);
[t,s]=ode23('vdpgtd',[t0 tf],s0,opt1,a); N=length(t);
f=real(s(N,2));
