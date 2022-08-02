function [f,y,v,a]=mfuel_f(p,N,v0,y0)                            
% Subroutine for p9_3_04b;        7/99, 3/29/02
% 
v=[v0 p 0]; y(1)=y0; dt=1/N;
a=(v(2:N+1)-v(1:N))/dt; vb=(v(2:N+1)+v(1:N))/2;
for i=1:N, y(i+1)=y(i)+dt*vb(i); end 
f=0; for i=1:N, f=f+abs(a(i)); end; f=f/N;		      