function lam= RidgeMatrix(TS);
% RIDGEMATRIX

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.



%   $Revision: 1.7.2.3 $  $Date: 2004/02/09 07:59:17 $

if islinear(TS)
	for i=1:length(TS.Global);
		lam{i}= RidgeMatrix(TS.Global{i});
	end
	lam= spblkdiag(lam{:});	
	if nnz(lam)==0
		lam=0;
	end
else
	lam=0;
end
