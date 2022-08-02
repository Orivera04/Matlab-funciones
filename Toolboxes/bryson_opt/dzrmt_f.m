function [f,x,y,ga]=dzrmt_f(p)                              
% Subroutine for p4_2_02; DVDP for min time to a point with uc=Vy/h 
% using FSOLVE; p=estimate of optimal [nux nuy dt]; f=[x-xf y-yf Om];
% s=[x,y]'; (x,y) in units of h, dt in h/V; 		   12/96, 7/25/02
%
xf=12; yf=0; N=20; nux=p(1); nuy=p(2); dt=p(3); x(1)=0; y(1)=0; Om=N;
%
% Forward sequence:
for i=1:N,  ga(i)=atan(dt*(N-i+1.5)+nuy/nux); c=cos(ga(i));
   s=sin(ga(i)); x(i+1)=x(i)+dt*(y(i)+c+dt*s/2); y(i+1)=y(i)+dt*s;
   Om=Om+nux*(y(i)+c)+s*(nuy+dt*nux*(N-i+1));
end
f=[x(N+1)-xf  y(N+1)-yf  Om]; 