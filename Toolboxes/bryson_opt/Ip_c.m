function [c,ceq,T,x,Tu,u]=ip_c(ts,ep,umax)               
% Subroutine for Pb. 9.3.13; erection of an inverted pendulum using 
% bang-bang force u on cart; cart mass=pendulum mass; abs(u)=1;
% s=[th thdot x xdot]'; ts=vector of switching times (last element
% =final time); time in units of sqrt(l/g), x in l, u in (M+m)g;
%                                                       3/94, 3/24/02
%
[T1,x1]=ode23('ipe',[0 ts(1)],[0 0 0 0]',[],ep,umax); m=length(T1);
[T2,x2]=ode23('ipe',[ts(1) ts(2)],x1(m,:)',[],ep,-umax); m=length(T2); 
T=[T1; T2(2:m)]; x=[x1; x2([2:m],:)]; p=length(ts);
if (-1)^p==-1, n=(p-1)/2; else n=p/2; end
for i=2:n,
   m=length(T);  [T1,x1]=ode23('ipe',[ts(2*i-2) ts(2*i-1)],...
      x(m,:)',[],ep, umax);
   m1=length(T1); [T2,x2]=ode23('ipe',[ts(2*i-1) ts(2*i)],...
      x1(m1,:)',[],ep,-umax); m=length(T2); 
   T=[T; T1(2:m1); T2(2:m)];  x=[x; x1([2:m1],:); x2([2:m],:)];
end
if 2*n<p,
   m=length(T); [T1,x1]=ode23('ipe',[ts(p-1) ts(p)],x(m,:)',...
      [],ep,umax);
   m=length(T1); T=[T; T1(2:m)]; x=[x; x1([2:m],:)];
end
m=length(T); xfd=[pi 0 0 0]; xf0=x(m,:); ceq=xf0-xfd; Tu=[0;0]; u=0;
for i=1:p,
   Tu=[Tu; ts(i); ts(i)]; u=[u; (-1)^i; (-1)^i];
end; u=-[u;0]; c=[];