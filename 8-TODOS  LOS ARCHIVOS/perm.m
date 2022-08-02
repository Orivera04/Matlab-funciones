function B = perm(A,i,j)
%PERM	Interchanges i-th and j-th rows of A.
%	The command is B=PERM(A,i,j).

%	Copyright 1993 Terry Lawson
%	Terry Lawson, Math Department, Tulane University, 11/93
B=A;
c=B(i,:);B(i,:)= B(j,:);B(j,:)=c;

