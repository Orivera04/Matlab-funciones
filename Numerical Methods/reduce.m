function [R,d]= reduce(A,b,tol);
%REDUCE	Calls gauss to give augmented matrix in reduced form. 
%	The command is [R,d]=REDUCE(A,b,tol).

%	Copyright 1993 Terry Lawson
%	Terry Lawson, Math Department, Tulane University, 11/93

[m,n]=size(A);
if (nargin < 3), tol = max([m,n])*eps*norm(A,'inf'); end
[u,o1,r,o]=gauss(A,tol);
 R=r;
d=o*b;

