function v=matmults(a,b)
% v=matmults(a,b). Matrix multiply using
% Fortran like triple loop
n=size(a,1); m=size(b,2); K=size(a,2);
v=zeros(n,m);
for i=1:n
   for j=1:m
      t=0;
      for k=1:K
         t=t+a(i,k)*b(k,j);
      end
      v(i,j)=t;
   end
end