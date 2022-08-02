clear;
clc;
m=input('No. a factorizar: ');
A= factor(m)
n=numel(A);
for i=1:n
 for j=i+1:n
   B(i,j)=A(i)*A(j);
 end
end
B=B';
C=reshape(B,(n-1)*n,1);
D=C(C~=0)