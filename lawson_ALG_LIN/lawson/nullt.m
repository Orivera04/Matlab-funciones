function v = nullt(A)
%NULLT	Finds null space of matrix using lsolve.
%	The  command is v = NULLT(A).

%	Copyright 1993 Terry Lawson
%	Terry Lawson, Math Department, Tulane University, 11/93

[m,n]=size(A);
b=zeros(m,1);
[v0,v1]=lsolve(A,b);
v=v1;
