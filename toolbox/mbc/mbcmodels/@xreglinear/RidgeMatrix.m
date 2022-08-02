function Lambda= RidgeMatrix(m);
% XREGLINEAR/RIDGEMATRIX

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.3 $  $Date: 2004/02/09 07:49:08 $



N= numParams(m);
if N==0
	Lambda=[];
else
	if isequal(m.lambda,0)
		Lambda= sparse(N,N);
	else
		termsin = Terms(m);
		if numel(m.lambda)==1
			lam= sqrt(m.lambda);
		else% local rols
			lam= sqrt(m.lambda(termsin));
		end
		
		switch m.qr
		case 'rols'
			B= triu(qr(m.Store.X(:,termsin),0));
			B= B(1:N,:);
			dB= diag(B);
			B = diag(1./dB)*B;
			
			Lambda= lam*B;
		otherwise
			if numel(lam)==1
				Lambda= lam*speye(N,N);
			else
				Lambda= spdiags(lam(:),0,N,N);
			end
		end
		
	end
	
end
	
