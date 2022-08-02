function [homsol,spsol]=lineq(a,b)
% solve linear equations a*x=b;
% [homsol,spsol]=lineq(a,b);
% lineq(a).
if nargin < 2 | isempty(b), [u,v]=size(a);b=zeros(u,1); end;
c=[a,b];
if rank(a)==rank(c)
[m,n]=size(c);
[s,t]=rref(c);
t1=t;
t2=1:n-1;
t2(t1)=[];
k=rank(a);
c=rowechon(c);
c1=c(1:k,t1);
c2=c(1:k,n);
 if k==n-1;
    spsol=inv(a)*b;
    homsol=zeros(n-1,1);
else
    spsol=sym(zeros(n-1,1));
    d=zeros(n-1-k,1);
    spsol([t1,t2])=[inv(c1)*c2;d];
    homsol=sym(zeros(n-1,n-1-k));
    for i=1:n-1-k
    d=zeros(n-1-k,1);
    d(i)=-1;
    temp=c(1:k,t2)*d;
    homsol([t1,t2],i)=[inv(c1)*temp;-d];
   end
end
else 
    disp('warning:no solution!')
end
