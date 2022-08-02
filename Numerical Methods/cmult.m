function B = cmult(A,i,r)
%CMULT	Multiplies i-th column of A by r.
%	The command is B=CMULT(A,i,r).

%	Copyright 1993 Terry Lawson
%	Terry Lawson, Math Department, Tulane University, 11/93
	
B=A;
B(:,i)=r*B(:,i);


