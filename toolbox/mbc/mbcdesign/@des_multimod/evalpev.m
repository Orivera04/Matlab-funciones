function PEV= evalpev(des,x,varargin);
% DES_MULTIMOD/EVALPEV
%
% PEV= evalpev(des,x,varargin);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:02:38 $

m= model(des);
wts=get(m,'weights');
mdls=get(m,'models');

PEV=0;
for i=1:length(wts);
	if wts(i)
		PEV= PEV + wts(i)*evalpev(x,mdls{i},varargin{:});
	end
end
