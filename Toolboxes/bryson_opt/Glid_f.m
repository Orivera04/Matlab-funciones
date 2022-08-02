function [f,al,x,h,ga,V,tf]=glid_f(p,h0,V0)                            
% Subroutine for Ex. 9.3.2;                            11/94,  9/17/02
%
N=length(p)/2; alm=1/12; eta=.5; V=[V0 p(1:N)]; ga=[0 p(N+1:2*N-1) 0];
tf=p(2*N); dt=tf/N; gad=(ga(2:N+1)-ga(1:N))/dt;
gab=(ga(2:N+1)+ga(1:N))/2; Vd=(V(2:N+1)-V(1:N))/dt;
Vb=(V(2:N+1)+V(1:N))/2; al=gad./Vb+cos(gab)./Vb.^2;
h(1)=h0; x(1)=0;
for i=1:N,
  h(i+1)=h(i)+dt*Vb(i)*sin(gab(i));
  x(i+1)=x(i)+dt*Vb(i)*cos(gab(i));
end
f=-x(N+1);		    