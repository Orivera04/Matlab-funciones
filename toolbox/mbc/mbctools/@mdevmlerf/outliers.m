function ol= outliers(mdev,NewOL)
%OUTLIERS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.3 $  $Date: 2004/02/09 08:05:45 $



if nargin==1
	p= Parent(mdev);
	ms= p.mle_stats;
	
	if isfield(ms,'Outliers')
		ol=  find( ms.Outliers(:,rfindex(mdev)) );
	else
		ol= [];
	end
else
	ms= p.mle_stats;
	
	ind= rfindex(mdev);

	
	ms.Outliers(:,ind)= false;
	ms.Outliers(NewOL,ind)= true;
	
	% update 
	p.mle_stats(ms);
	p.status(0);

	

	ol= info(mdev);
	
end
