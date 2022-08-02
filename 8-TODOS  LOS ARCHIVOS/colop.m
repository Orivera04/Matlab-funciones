function B=colop(A,i,j,r)
%COLOP	Adds r times j-th column of A to i-th column. 
%	The command is B=COLOP(A,i,j,r). 

%	Copyright 1993 Terry Lawson
%	Terry Lawson, Math Department, Tulane University, 11/93

B=A;
B(:,i)=B(:,i)+r*B(:,j);

