function [Q,R]=gram(A,B,tol)   
%GRAM	Computes QR decomposition of A. 
% 	It uses the Gram-Schmidt algorithm. 
%	The inner product is given by <x,y>=x^tBy. 
%	If B is not given it is assigned to eye(m),
%	This just gives the usual dot product.
% 	The command is [Q,R]=GRAM(A,B,tol). 
%	tol is computed automatically if omitted.

%	Copyright 1993 Terry Lawson
%	Terry Lawson, Math Department, Tulane University, 11/93

[m,n]=size(A);
if (nargin < 2), B=eye(m); end
if (nargin < 3), tol = max([m,n])*eps*norm(A,'inf'); end
v=A;
R=zeros(m,n);
k=1;w(:,1)=v(:,1);R(1,1)=sqrt(w(:,1)'*B*w(:,1));
Q(:,1)=w(:,1)/R(1,1);nn(1)=R(1,1);
for j= 2:n  
  wtemp = v(:,j);
  for i= 1:k
    t(i,j)=v(:,j)'*B*w(:,i)/(w(:,i)'*B*w(:,i));
    wtemp = wtemp-t(i,j)*w(:,i);
    R(i,j)=t(i,j)*nn(i);
  end                  
  if sqrt(wtemp'*B*wtemp) > tol
    k=k+1;
    w(:,k)=wtemp;
    nn(k)=sqrt(wtemp'*B*wtemp);
    R(k,j)=nn(k);
    Q(:,k)=w(:,k)/nn(k);
  end
end
R=R(1:k,:);


