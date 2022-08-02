function [B,Xinv,Ri]= xreglsq(X,y,lam,doPrecond)
% XREGLSQ linear least squares for large sparse problems
%
% [B,Xinv,Ri]= xreglsq(X,y,lam,doPrecond);
% Note xreglsq will add a ridge matrix so an answer is always returned.
% 
% Inputs
%   X          Regression Matrix
%   y          Output Data
%   lam        Ridge matrix (can be 0)
%   doPreCond  precondition regression matrix with column norms
% Outputs
%   B          lsq coefficients
%   Xinv       pseudo inverse
%   Ri         inverse of R from qr

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.6.2.2 $  $Date: 2004/02/09 08:02:25 $


if nargin<3
	lam=0;
end
if nargin<4
	doPrecond=1;
end

N= size(X,2);
if nnz(lam)>0 
	if any(size(lam)==1)
		if numel(lam)==1
			L= lam*speye(N,N);
		else
			% diagonal matrix
			L= spdiags(lam,0,N,N);
		end
	else
		L= lam;
	end
end


if doPrecond
	% precondition X matrix
	[Xs,sd,Si]= xregprecond(X);
else
	Xs= X;
	sd=1;
end

if ~nnz(lam)
	if issparse(Xs)
		% use q-less decompostion for sparse 
		[qy,R] = qr(Xs,y,0);
	else
		% full qr decompostion
		[Q,R]= qr(Xs,0);
		qy= Q'*y;
	end
	rd= abs(diag(R));
	tol= size(Xs,1)*eps*max(rd);
	if ~any(lam) & any(rd<tol) ;
		% use ridge regression
		% would like an option to 
		if issparse(Xs)
			lam= svds(Xs,1)+1;
		else
			lam= norm(Xs)+1;
		end
		L=  sqrt(lam)*lam*speye(N);
	end
end
if nnz(lam)
	% augment qr for ridge
	XL= [Xs;L];
	yL= [y; zeros(size(L,1),1)];
	if issparse(XL)
		% use q-less decompostion for sparse 
		[qy,R] = qr(XL,yL,0);
	else
		% full qr decompostion
		[Q,R]= qr(XL,0);
		qy= Q'*yL;
	end
	
	
	% rescale coefficients 
	% B= sd*(R\(R'\(XL'*yL)));
	B= sd*(R\qy);
else
	% q-less decomposition
	x = R\qy;
	if issparse(Xs)
		% iterative refinement
		r = y - Xs*x;
		e = R\(R'\(Xs'*r));
		% scale solution
		x = (x + e);	
	end
	B= sd*x;
end

if nargout>1
	% pseudo inverse
	Xinv=  sd*((Xs/R)/R')';
end
if nargout>2
	% inverse of R
	Ri= sd*inv(R);
end
