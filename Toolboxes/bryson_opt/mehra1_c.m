function [c,ceq]=mehra1_c(p)
% Subroutine for mehra1.m;                                1/10/02
%
dt=.05; x2=[-1 p]; 
for k=1:20, x2b(k)=(x2(k+1)+x2(k))/2; x2d(k)=(x2(k+1)-x2(k))/dt; 
end
t1=.025:.05:.975; x1(1)=0; 
for k=1:20, x1(k+1)=x1(k)+x2b(k)*dt; x1b(k)=(x1(k+1)+x1(k))/2;
      c(k)=x1b(k)-8*(t1(k)-.5)^2+.5; 
end
ceq=[];


