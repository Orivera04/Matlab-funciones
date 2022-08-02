function md= mdevmlerf(mdev,m,DS)
% MDEVMLERF

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:05:42 $


loadstr=0;
if nargin==0
	mdev= modeldev;
	m= [];
	DS= [];
	loadstr=1;
end




if strcmp(class(mdev),'modeldev')
	md.Model    = m;
	md.DiagStats= DS;
	md.RandomEffects= [];
	md= class(md,'mdevmlerf',mdev);
	
	if ~loadstr
		pointer(md);
	end
else
	% update mle models
	
	md= mdev;
	md.Model    = m;
	md.DiagStats= DS;
	md.RandomEffects= [];
	
	pointer(md);
	
end

