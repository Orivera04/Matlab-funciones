function a=forms(b)
%FORMS - FORMs Symm. matrix from column vector or vice-versa 
% a=forms(b)
% If b=column vector, a=symm. matrix;  b=symm. matrix,
% a=column vector; Sun H. Hur 12/92, rev. AEB 8/7/97
%
[nr,nc]=size(b);
if nc==1, n=sqrt(2*nr+1/4)-1/2; a=zeros(n);
 if n==1, a=b;
 else S1=zeros(n,n); a=S1;
   for i=1:n, j=1+(i-1)*(2*n+2-i)/2;
    k=i*(2*n+1-i)/2; S1(i,i:n)=b(j:k)';
   end; a=S1+S1'-diag(diag(S1)); 
 end
else n=nr; a=zeros(n*(n+1)/2,1);
   for i=1:n, j=(i-1)*(2*n+2-i)/2+1;
     k=i*(2*n+1-i)/2; a(j:k)=b(i,i:n)';
   end
end
	
  
