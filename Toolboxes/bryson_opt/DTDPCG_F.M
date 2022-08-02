function [f,u,v,y,x,be]=dtdpcg_f(p,N,g,xf,yf)
% Subroutine for Pb. 3.1.10; DTDP for max uf with gravity and (vf,xf,yf)
% specified; finds nuv, nuy, nux in analytic solution for be(i) to satisfy
% terminal BCs using FSOLVE;  s=[u v y x]';  	            11/96, 6/10/98
%
nuv=p(1); nuy=p(2); nux=p(3); tf=1; dt=tf/N;
u(1)=0; v(1)=0; y(1)=0; x(1)=0;
for i=1:N,
   be(i)=atan2(nuv+nuy*(1-(i-.5)/N),1+nux*(1-(i-.5)/N)); c=cos(be(i));
   s=sin(be(i)); u(i+1)=u(i)+dt*c;  v(i+1)=v(i)+dt*(s-g); 
   y(i+1)=y(i)+dt*v(i)+dt^2*(s-g)/2; x(i+1)=x(i)+dt*u(i)+dt^2*c/2;
end;
f=[v(N+1) y(N+1)-yf x(N+1)-xf];

	


	


