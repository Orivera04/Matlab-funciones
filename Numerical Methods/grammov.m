function [Q,R]=grammov(A,tol)
%GRAMMOV Gives movie of Gram-Schmidt algorithm.
%        We start with a matrix A whose columns 
%        provide the original spanning set vi of the 
%        range of A. We compute an orthogonal basis 
%        w1,...,wr inductively, as well as the corresponding 
%        orthonormal basis q1,...,qr. The end output is 
%        Q,R so that A=QR. The command is [Q,R]=GRAMMOV(A).
%        In general Q will be an orthonormal basis for the 
%        range of A and R will give the coefficients which 
%        express the original columns of A in terms of the 
%        orthonormal basis. Q will be m by r and R will be 
%        r by n.When the columns of A are independent, R 
%        will be an invertible n by n matrix;in general, R will
%        have rank r. The intermediate output t gives the 
%        coefficients of the wi to be subtracted off to make the 
%        next vector orthogonal.
	 
	
%	 Copyright 1993 Terry Lawson
%	 Terry Lawson, Math Department, Tulane University, 11/93

[m,n]=size(A);
if (nargin < 2), tol = max([m,n])*eps*norm(A,'inf'); end
v=A;
R=zeros(m,n);           
%we do the first step
k=1;w(:,1)=v(:,1),R(1,1)=norm(w(:,1)),Q(:,1)=w(:,1)/R(1,1),nn(1)=R(1,1);  
pause
for j= 2:n  
  wtemp = v(:,j);
  for i= 1:k   
    clc,home
    t(i,j)=v(:,j)'*w(:,i)/(w(:,i)'*w(:,i))
    wtemp = wtemp-t(i,j)*w(:,i)
    R(i,j)=t(i,j)*nn(i)
    pause
  end                  
  if norm(wtemp) > tol
    clc,home
    k=k+1;
    w(:,k)=wtemp
    nn(k)=norm(wtemp);
    R(k,j)=nn(k)
    Q(:,k)=w(:,k)/nn(k)
    pause
  end
end
R=R(1:k,:);

