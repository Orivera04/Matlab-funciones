function [S,W,cj]=Sigma(L,X,Wc);
% LOCALMOD/SIGMA Response feature Covariance matrix
%
% S=Sigma(f,X,Wc);
%   L localmod
%   X in coded units (this includes datum!)
%   Wc weighting matrix (optional)
%  Outputs
%   S  covariance of response features (= delG*inv(J'*J)*delG' )
%   W  covariance of parameters
%   cj condition numbers of jacobiam and covariance matrix
%   
%  Note this needs to be scaled by mse before use

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:39:39 $

dG= L.delG;

if nargin < 3
   Wc=[];
end
% QR decomposition inv(J'*J) = inv(R'*R)
[ri,s,df]= var(L);
if isempty(ri)
	L= pevinit(L,X);
	[ri,s,df]= var(L);
end
   


if df>0
	W= ri*ri';
	S= dG*ri;
	S= S*S';
	if all(isfinite(ri(:))) & nargout > 2
		J= jacobian(L,X,1);
		cj= cond(J);
		if issparse(W)
			cj= [cj condest(W)];
		else
			cj= [cj cond(W)];
		end
	else
		cj= [Inf Inf];
	end
else
	W= ri*ri';
	S= zeros(size(dG,1));
	S(:)= NaN;
	cj= [Inf Inf];
end


