function P=borraFSNU(A,N)
B=A;
y=0;
[m,n]=size(A);
for i=1:m
    x=A(i,:);
    if x(end)~=N
      y(i)=i;
    end
end
%clc
k=find(y~=0);
B(k,:)=[];
P=B;