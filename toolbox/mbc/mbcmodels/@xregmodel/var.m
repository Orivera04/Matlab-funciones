function varargout= var(m,Rinv,mse,df);
% MODEL/VAR residual variance
%
% [Rinv,mse,df]= var(m);
% Inputs
%    m
% Outputs 
%    Rinv   Rinv*Rinv' = inv(X'*X)*mse (upper triangular matrix needed for pev calcs)
%    mse    mean squared error sum((y-yhat).^2/df)
%    df     residual degrees of freedom      n-p
% 
%  m= var(m,Rinv,mse,df); to store variance

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:53:23 $

if nargin == 1
	varargout= {m.Stats.Rinv,m.Stats.mse,m.Stats.df};
else
	if ~isempty(Rinv) & size(Rinv,1)~=size(Rinv,2)
		% reduce Rinv to a square matrix
		Rinv= qr(Rinv');
		Rinv= triu(Rinv(1:size(Rinv,2),:))';
	end
	
	m.Stats.Rinv= Rinv;
	if ~isempty(mse)
		m.Stats.mse = mse;
	end
	if ~isempty(df)
		m.Stats.df = df;
	end
	varargout{1}= m;
end
	


