function [f,x,u]=mehra1_f(p)
% Subroutine for mehra1.m;                              1/10/02
%
dt=.05; x2=[-1 p]; for k=1:20, x2b(k)=(x2(k+1)+x2(k))/2;
    x2d(k)=(x2(k+1)-x2(k))/dt; u(k)=x2d(k)+x2b(k); end
x1(1)=0; J(1)=0;
for k=1:20, x1(k+1)=x1(k)+x2b(k)*dt; x1b(k)=(x1(k+1)+x1(k))/2;
   J(k+1)=J(k)+dt*(x1b(k)^2+x2b(k)^2+.005*u(k)^2); end 
f=J(21); x=[x1; x2];
