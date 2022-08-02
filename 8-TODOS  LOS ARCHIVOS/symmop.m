function [B,P]=symmop(A,r)
%SYMMOP	Does one symmetric row and column operation. 
%       It puts a symmetric matrix into normal form. 
%       The syntax is [B,P]=SYMMOP(A,r).Then B=P^tAP. 
%       It is applied when the first r-1 rows and columns  
%       are in diagonal form. 

%	Copyright 1993 Terry Lawson
%	Terry Lawson, Math Department, Tulane University, 11/93
if (nargin < 2) r=1;end
[m,n]=size(A);
P=eye(m);B=A;
for i=r+1:m
B=rowop(B,i,r,-B(i,r)/B(r,r));
P=rowop(P,i,r,-A(i,r)/A(r,r));
end
for i=r+1:m
B(r,i)=0;
end
P=P';

