function r=rank(des,tol)
%RANK   Matrix rank.
%   RANK(DES) provides an estimate of the number of linearly
%   independent rows or columns of the regression matrix.
%   RANK(DES,tol) is the number of singular values in the regression matrix
%   that are larger than tol.
%   RANK(DES) uses the default tol = max(size(X)) * norm(X) * eps.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:07:35 $

% Created 29/9/2000


m=model(des);
if ~isempty(m) & ~isempty(des.design) & islinear(m)
   X=x2fx(m,des.design);
   
   if nargin>1
      r=rank(X,tol);
   else
      r=rank(X);
   end
else
   r=0;
end
return
