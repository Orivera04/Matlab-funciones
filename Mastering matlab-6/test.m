% r=s(:,end:-1:1)
% a=~isspace(r)
% %a=r=='o'
% b=cumsum(a,2)
% c=b~=0
% d=sum(c,2)
% 
% %[i,j]=find(s=='o')
% [i,j]=find(a);
% jj=zeros(length(d),1);
% jj(i)=j


x=[0 9 7 0 0 0
   5 0 0 6 0 3
   0 0 0 0 0 0
   8 0 4 2 1 0];

r=x(:,end:-1:1)
a=r~=0
b=cumsum(a,2)
c=b~=0
d=sum(c,2)


[i,j]=find(x~=0);
[m,n]=size(x);
jj=zeros(m,1);
ii=zeros(n,1);

jj(i)=j
ii(j)=i