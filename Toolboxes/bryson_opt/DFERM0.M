function [f,x,y]=dferm0(th,tf)
% Subroutine for use with FSOLVE for Pb. 2.1.4; discrete Fermat
% Pb., max range with velocity magnitude=1+y;     10/96, 7/24/02
%
N=length(th); dt=tf/N; x(1)=0; y(1)=0; ly(N+1)=0; 
for i=1:N
   b(i)=exp(dt*sin(th(i))); z(i)=tan(th(i));
   x(i+1)=x(i)+(1+y(i))*(b(i)-1)/z(i); y(i+1)=b(i)*(1+y(i))-1;
end
for i=N:-1:1
   ly(i)=(b(i)-1)/z(i)+b(i)*ly(i+1); s=sin(th(i)); c=cos(th(i));	
   f(i)=dt*b(i)*c^2/s-(b(i)-1)/s^2+ly(i+1)*b(i)*dt*c;
end
	        
	
	
