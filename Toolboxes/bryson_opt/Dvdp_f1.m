function [f,v,y,x]=dvdp_f1(p,N,h)
% Subroutine for Pb. 9.3.9; DVDP for min time to x=xf w. y<=h+x*tan(th);
% p=[u(1),...,u(N),tf]; tf=final time; N=no. steps; t in sqrt(xf/g),
%(x,y) in xf, V in sqrt(g*xf);                     12/94, 11/96, 4/12/98
%
th=atan(.5); for i=1:N, u(i)=p(i); end; tf=p(N+1);
dt=tf/N; v(1)=0; x(1)=0; y(1)=0;
for i=1:N, si=sin(u(i)); co=cos(u(i)); dl=dt*v(i)+dt^2*si/2;
   x(i+1)=x(i)+dl*co; y(i+1)=y(i)+dl*si; v(i+1)=v(i)+dt*si;
end
f=tf;
  