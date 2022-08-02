
function [v0,v] = rdsolve(R,b,bcol,fcol)
%RDSOLVE Solves system in reduced normal form.
%        The command is [v0,v] = RDSOLVE(R,b,bcol,fcol).
%        Given a matrix A in reduced normal form, v0 is a 
%        particular solution of Ax = b,where b is a given
%        r by 1 column vector.  Here A is r by n, the zero 
%        rows having been omitted, bcol contains the basic
%        columns, and fcol contains the free columns.

%	 Copyright 1993 Terry Lawson
%	 Terry Lawson, Math Department, Tulane University, 11/93

[r,n]=size(R);
 v0=zeros(n,1);
for i=1:r
 v0(bcol(i),1) = b(i,1);
end 
if r == n 
v = [];
else
 v = zeros(n,n-r);
for i = 1:n-r
 for j = 1:r
 v(bcol(j),i) = -R(j,fcol(i));
 end
 v(fcol(i),i) = 1;
end
end
% TL 1/19/87





