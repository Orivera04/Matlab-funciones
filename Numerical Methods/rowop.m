function B=rowop(A,i,j,r)
%ROWOP	Adds r times j-th row to i-th row.
%	The command is B=ROWOP(A,i,j,r). 

%	Copyright 1993 Terry Lawson
%	Terry Lawson, Math Department, Tulane University, 11/93

B=A;
B(i,:)=B(i,:)+r*B(j,:);

