function y=twopoint(x,C,D,E,F,flag1,flag2,p1,p2)
% Solves 2nd order boundary value problem: see equation, page 210.
%
% Example call: y=twopoint(x,C,D,E,F,flag1,flag2,p1,p2)
% x is a row vector of n+1 nodal points.
% C, D, E and F are row vectors specifying C(x), D(x), E(x) and F(x).
% If y is specified at node 1, flag1 must equal 1. If y' is specified at node 1, flag1 must equal 0.
% If y is specified at node n+1, flag2 must equal 1. If y' is specified at node n+1, flag2 must equal 0.
% p1 and p2 are boundary values (y or y') at nodes 1 and n+1 repectively.
%
n=length(x)-1;
h(2:n+1)=x(2:n+1)-x(1:n);
h(1)=h(2); h(n+2)=h(n+1);
r(1:n+1)=h(2:n+2)./h(1:n+1);
s=1+r;
%flag1=1, y  specified at node 1. 
%flag1=0, y' specified at node 1.
%flag2=1, y  specified at node n+1. 
%flag2=0, y' specified at node n+1.
if flag1==1
  y(1)=p1;
else
  slope0=p1;
end
if flag2==1
  y(n+1)=p2;
else
  slopen=p2;
end
W=zeros(n+1,n+1);
if flag1==1
  c0=3;
  W(2,2)=E(2)-2*C(2)/(h(2)^2*r(2));
  W(2,3)=2*C(2)/(h(2)^2*r(2)*s(2))+D(2)/(h(2)*s(2));
  b(2)=F(2)-y(1)*(2*C(2)/(h(2)^2*s(2))-D(2)/(h(2)*s(2)));
else
  c0=2;
  W(1,1)=E(1)-2*C(1)/(h(1)^2*r(1));
  W(1,2)=2*C(1)*(1+1/r(1))/(h(1)^2*s(1));
  b(1)=F(1)+slope0*(2*C(1)/h(1)-D(1));
end
if flag2==1
  c1=n-1;
  W(n,n)=E(n)-2*C(n)/(h(n)^2*r(n));
  W(n,n-1)=2*C(n)/(h(n)^2*s(n))-D(n)/(h(n)*s(n));
  b(n)=F(n)-y(n+1)*(2*C(n)/(h(n)^2*s(n))+D(n)/(h(n)*s(n)));
else
  c1=n;
  W(n+1,n+1)=E(n+1)-2*C(n+1)/(h(n+1)^2*r(n+1));
  W(n+1,n)=2*C(n+1)*(1+1/r(n+1))/(h(n+1)^2*s(n+1));
  b(n+1)=F(n+1)-slopen*(2*C(n+1)/h(n+1)+D(n+1));
end
for i=c0:c1
  W(i,i)=E(i)-2*C(i)/(h(i)^2*r(i));
  W(i,i-1)=2*C(i)/(h(i)^2*s(i))-D(i)/(h(i)*s(i));
  W(i,i+1)=2*C(i)/(h(i)^2*r(i)*s(i))+D(i)/(h(i)*s(i));
  b(i)=F(i);
end
z=W(flag1+1:n+1-flag2,flag1+1:n+1-flag2)\b(flag1+1:n+1-flag2)';
if flag1==1 & flag2==1, y=[y(1); z; y(n+1)]; end
if flag1==1 & flag2==0, y=[y(1); z]; end
if flag1==0 & flag2==1, y=[z; y(n+1)]; end
if flag1==0 & flag2==0, y=z; end
