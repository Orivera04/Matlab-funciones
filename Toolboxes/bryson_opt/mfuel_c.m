function [c,ceq]=mfuel_c(p,N,v0,y0)                            
% Subroutine for p9_3_04b;        7/99, 3/29/02
% 
v=[v0 p 0]; y(1)=y0; dt=1/N;
a=(v(2:N+1)-v(1:N))/dt; vb=(v(2:N+1)+v(1:N))/2;
for i=1:N,
  y(i+1)=y(i)+dt*vb(i); c(i)=abs(a(i))-1; 
end; ceq=y(N+1);
