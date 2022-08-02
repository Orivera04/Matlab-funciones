function B = cperm(A,i,j)
%CPERM	Interchanges i-th and j-th columns of matrix.	
%	The command is B=CPERM(A,i,j).

%	Copyright 1993 Terry Lawson
%	Terry Lawson, Math Department, Tulane University, 11/93
B=A;
c=B(:,i);B(:,i)= B(:,j);B(:,j)=c;

