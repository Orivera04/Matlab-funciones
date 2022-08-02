function [W,t]=gramop(V,A)
%GRAMOP	Executes one step of Gram-Schmidt algorithm.
%        This replaces the last element vk of independent  
%        vectors w1,w2,...,w(k-1),vk in R^m where the 
%        first k-1 vectors are orthogonal with wk so that 
%        all vectors are orthogonal.The matrix V has 
%        w1,...,w(k-1),vk as columns. For the usual dot 
%        product leave out the second argument and A 
%        is assigned the value eye(m). The inner product 
%        is given in terms of A by <x,y>=x^tAy. This is useful 
%        for other inner products.
%        The syntax is [W,t]=GRAMOP(V,A).

%	Copyright 1993 Terry Lawson
%	Terry Lawson, Math Department, Tulane University, 11/93
 
[m,n]=size(V);
if (nargin < 2), A=eye(m); end
W=V(:,1:(n-1));
t=zeros(1,n-1);
for i=1:(n-1) t(1,i)=V(:,n)'*A*W(:,i)/(W(:,i)'*A*W(:,i)); end 
W(:,n)=V(:,n);
for i=1:(n-1)
W(:,n)=W(:,n)-t(1,i)*W(:,i);
end

