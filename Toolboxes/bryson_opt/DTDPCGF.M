function [f,u,v,y,x,th]=dtdpcgf(p,N,g,yf)
% Subroutine for Pb. 3.1.9; DTDP for max uf with gravity and (vf,xf) spec.;
% finds (nuv, nuy) in linear tangent law to satisfy terminal BCs using
% FSOLVE; s=[u v y x]';                                 2/97, 1/98, 6/10/98
%
dt=1/N; vf=0; nuv=p(1); nuy=p(2); u(1)=0; v(1)=0; y(1)=0; x(1)=0;
for i=1:N,
   th(i)=atan(nuv+nuy*(1-(i-.5)/N)); c=cos(th(i)); s=sin(th(i));
   u(i+1)=u(i)+dt*c; v(i+1)=v(i)+dt*(s-g);
   y(i+1)=y(i)+dt*v(i)+(dt^2/2)*(s-g); x(i+1)=x(i)+dt*u(i)+dt^2*c/2;
end;
f=[v(N+1) y(N+1)-yf];

	


	


