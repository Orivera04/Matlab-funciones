function [v0,v]= lsolve(A,b,tol)
%LSOLVE	Solves Ax = b using gauss.
%       This function gets the equivalent equation
%       Rx = d at the end of the Gaussian elimination algorithm  
%       by calling gauss and then either notes that there is  
%       no solution or calls rdsolve  to give a particular  
%       solution v0 and a general solution v to the homogeneous 
%       equation. The command is [v0,v]= LSOLVE(A,b,tol).

%	Copyright 1993 Terry Lawson
%	Terry Lawson, Math Department, Tulane University, 11/93
[m,n]=size(A);
if (nargin < 3), tol = max([m,n])*eps*norm(A,'inf');end
[U,O1,R,O,bcol,fcol]=gauss(A,tol);
[r0,r]=size(bcol); 
d=O*b;
R=R(1:r,:);
if (r < m) 
mm =  max(abs(d(r+1:m,1)));
d=d(1:r,:);
end
if mm > tol
disp(['there is no solution'])  
else
[v0,v]=rdsolve(R,d,bcol,fcol);
end

