function [f,u,v,y,x,th]=dtdpcgxf(y1,N,g,xf,yf)
% Subroutine for Pb. 3.1.10; DTDP for max uf with gravity and (vf,xf,yf
% specified; finds nuv, nuy, nux in bilinear tangent law to satisfy
% terminal BCs using FSOLVE;  s=[u v y x]';               2/97, 6/10/98
%
nuv=y1(1); nuy=y1(2); nux=y1(3); dt=1/N; u(1)=0; v(1)=0; y(1)=0; x(1)=0;
for i=1:N,
   th(i)=atan2(nuv+nuy*(1-(i-.5)/N),1+nux*(1-(i-.5)/N)); c=cos(th(i));
   s=sin(th(i)); u(i+1)=u(i)+dt*c;  v(i+1)=v(i)+dt*s-g*dt;
 y(i+1)=y(i)+dt*v(i)+dt^2*s/2-dt^2*g/2; x(i+1)=x(i)+dt*u(i)+dt^2*c/2;
end;
f=[v(N+1) y(N+1)-yf x(N+1)-xf];

	


	


