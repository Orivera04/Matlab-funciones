function [eigs,vecs,Amat,Bmat]=eigenrec(A,B,C,D)
% [eigs,vecs,Amat,Bmat]=eigenrec(A,B,C,D)
% Solve a rectangular eigenvalue problem of the
% form: X*A+B*X=lambda*(X*C+D*X)
n=size(B,1); m=size(A,2); s=[n,m]; N=n*m; 
Amat=zeros(N,N); Bmat=Amat; kn=1:n; km=1:m;
for i=1:n
  IK=sub2ind(s,i*ones(1,m),km);  
  Bikn=B(i,kn); Dikn=D(i,kn);
  for j=1:m
    I=sub2ind(s,i,j); 
    Amat(I,IK)=A(km,j)'; Bmat(I,IK)=C(km,j)'; 
    KJ=sub2ind(s,kn,j*ones(1,n));
    Amat(I,KJ)=Amat(I,KJ)+ Bikn;
    Bmat(I,KJ)=Bmat(I,KJ)+ Dikn;
   end
end
[vecs,eigs]=eig(Bmat\Amat); 
[eigs,k]=sort(diag(eigs));
vecs=reshape(vecs(:,k),n,m,N);