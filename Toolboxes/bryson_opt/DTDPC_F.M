function [f,u,v,y,x,th]=dtdpc_f(y1)
% Subroutine for Pb. 3.1.7; DTDP for max uf with vf=0 & (xf,yf) speci-
% fied; finds nu in analytic solution for th(i) to satisfy terminal BCs 
% using FSOLVE;  s=[u v y x]';                             2/97, 6/9/98
%
vf=0; yf=.2; xf=.15; nuv=y1(1); nuy=y1(2); nux=y1(3); N=40; tf=1;
dt=tf/N; u(1)=0; v(1)=0; y(1)=0; x(1)=0;
for i=1:N,
   th(i)=atan2(nuv+nuy*(1-(i-.5)/N),1+nux*(1-(i-.5)/N)); c=cos(th(i));
   s=sin(th(i)); u(i+1)=u(i)+dt*c;  v(i+1)=v(i)+dt*s;
   y(i+1)=y(i)+dt*v(i)+dt^2*s/2; x(i+1)=x(i)+dt*u(i)+dt^2*c/2;
end;
f=[v(N+1) y(N+1)-yf x(N+1)-xf];

	


	


