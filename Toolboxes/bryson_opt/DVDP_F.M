function [f,v,x]=dvdp_f(ga,s0,tf,N)                           
% Subroutine for e02_2_2.m;                  11/94, 3/23/02
%
dt=tf/N; v(1)=s0(1); x(1)=s0(2);
for i=1:N, x(i+1)=x(i)+dt*v(i)*cos(ga(i))+dt^2*sin(2*ga(i))/4;
   v(i+1)=v(i)+dt*sin(ga(i));  
end
f=-x(N+1);
  
