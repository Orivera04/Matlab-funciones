function s= BestModelString(mdev);
% MODELDEV/BESTMODELSTRING

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.3 $  $Date: 2004/02/09 08:03:56 $



ind= BMIndex(mdev);

if ind==0 
	s='No two-stage model is selected';
else
	L= model(mdev);
	selrf= mdev.ResponseFeatures(ind,:)+RFstart(L);
	n= children(mdev,selrf,'name');
	
	s= sprintf('%s, ',n{:});
	s= s(1:end-2);
	if mle_best(mdev)
		st= children(mdev,'status');
		if sum([st{:}]==2)~=size(L,1)+RFstart(L)
			s= ['MLE Model needs updating'];
		else
			s= ['MLE Model with ',s];
			s= [s ' is the best two-stage model'];
		end
	else
		s= ['Univariate Model with ',s];
		s= [s ' is the best two-stage model'];
	end
end
