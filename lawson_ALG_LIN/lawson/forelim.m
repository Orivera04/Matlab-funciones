function [U,B]= forelim(A,b,tol);
%FORELIM Gives result after forward elimination.
%	 It calls the routine gauss .
%	 The command is [U,c]=FORELIM(A,b,tol). 
%	 The optional variable tol can be adjusted 
%	 to zero out small entries < tol. 

%	 Copyright 1993 Terry Lawson
%	 Terry Lawson, Math Department, Tulane University, 11/93

[m,n]=size(A);
if (nargin < 3), tol = max([m,n])*eps*norm(A,'inf'); end
[u,o1,r,o,bcol,fcol]=gauss(A,tol);
U=u;
B=o1*b;

