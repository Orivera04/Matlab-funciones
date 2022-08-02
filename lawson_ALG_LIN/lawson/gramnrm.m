function [Q,N]=gramnrm(W,A)
%GRAMNRM Gives orthonormal basis from orthogonal one.
%        This routine corresponds to the last step of 
%        Gram-Schmidt. The vector N is the lengths of 
%        the vectors in the columns of W and Q comes 
%        from W by making the columns unit vectors.
%        The inner product is given by <x,y>=x^tAy. If no 
%        second argument is given A is taken as eye(m), 
%        which just gives the usual dot product. The syntax 
%        is [Q,N]=GRAMNRM(W,A).

%	 Copyright 1993 Terry Lawson
%	 Terry Lawson, Math Department, Tulane University, 11/93


[m,n]=size(W);
if (nargin < 2) , A=eye(m);end
for i=1:n N(1,i)=sqrt(W(:,i)'*A*W(:,i)); end
for i=1:n Q(:,i)=(1/N(1,i))*W(:,i); end
 

