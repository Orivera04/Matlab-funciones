function [f,g,T,x,Tu,u]=ip(ts,ep,umax)               
% Subroutine for Pb. 9.3.13;                               3/94, 12/6/01
%
x0=zeros(4,1);
[T1,x1]=ode23('ipe',[0     ts(1)],x0       ,[],ep, umax); m1=length(T1);
[T2,x2]=ode23('ipe',[ts(1) ts(2)],x1(m1,:)',[],ep,-umax); m2=length(T2);
[T3,x3]=ode23('ipe',[ts(2) ts(3)],x2(m2,:)',[],ep, umax); m3=length(T3);
[T4,x4]=ode23('ipe',[ts(3) ts(4)],x3(m3,:)',[],ep,-umax); m4=length(T4);
[T5,x5]=ode23('ipe',[ts(4) ts(5)],x4(m4,:)',[],ep, umax); m5=length(T5);
[T6,x6]=ode23('ipe',[ts(5) ts(6)],x5(m5,:)',[],ep,-umax); 
T=[T1(1:m1-1);   T2(1:m2-1);   T3(1:m3-1);   T4(1:m4-1); ...
   T5(1:m5-1);   T6];
x=[x1(1:m1-1,:); x2(1:m2-1,:); x3(1:m3-1,:); x4(1:m4-1,:); ...
   x5(1:m5-1,:); x6];
f=ts(6); m=length(T); xfd=[pi 0 0 0]; xf0=x(m,:); g=xf0-xfd;
Tu=[0;0]; u=0;
for i=1:6,
  Tu=[Tu; ts(i); ts(i)]; u=[u; (-1)^i; (-1)^i];
end; u=-[u; 0];
