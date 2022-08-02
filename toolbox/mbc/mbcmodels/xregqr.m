function [Q,R,OK]= xregqr(X,tol);
% XREGQR qr decomposition with rank chank
%
% [Q,R,OK]= xregqr(X,tol);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:02:28 $

[Q,R]= qr(X,0);
if size(X,1)<size(X,2)
   OK=0;
   return;
end
rd= abs(diag(R));
if nargin==1
	tol= length(X)*eps*max(rd);
end
OK=  ~(size(X,2)>size(Q,1) | any(rd<tol));
   
