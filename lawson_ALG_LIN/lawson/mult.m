function B = mult(A,i,r)
%MULT	Multiplies the i-th row by r. 
%	The command is B=MULT(A,i,r).

%	Copyright 1993 Terry Lawson
%	Terry Lawson, Math Department, Tulane University, 11/93

B=A;B(i,:)=r*B(i,:);


