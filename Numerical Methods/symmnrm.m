function [B,P]=symmnrm(A)
%SYMMNRM Normalizes diagonal matrix.
%        It makes the diagonal entries 1,-1,0. We  
%        have P^tAP=B. The syntax is [B,P]=SYMMNRM(A).

%	 Copyright 1993 Terry Lawson
%	 Terry Lawson, Math Department, Tulane University, 11/93

[m,n]=size(A);
P=eye(m);
for i=1:m
if norm(A(i,i))>eps 
P(i,i)=1/sqrt(abs(A(i,i)));
end
end
B=P'*A*P;
 
