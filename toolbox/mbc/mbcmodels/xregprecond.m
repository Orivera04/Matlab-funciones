function [Xs,S,Si]= xregprecond(X);
% XREGPRECOND preconditioner for least squares problems
% 
% [Xs,S]= xregprecond(X);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:02:27 $

% use column norms
sp= sqrt(sum(X.*X,1))';
% protect against dividing by very small numbers
sp = max(sp,sqrt(eps));
n= length(sp);
if max(sp)/min(sp)>1e4
	% use sparse diagonal matrix because this is far quicker
	% note spdiags doesn't like row vectors
	S= spdiags(1./sp,0,n,n);
	Si= spdiags(sp,0,n,n);
	Xs= X*S;
else
	% don't precondition for well-conditioned problems
	Xs= X;
	S= speye(n,n);
	Si=S;
end



