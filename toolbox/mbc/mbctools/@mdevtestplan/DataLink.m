function D= DataLink(T,newDL);
% MDEVTESTPLAN/DATALINK

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:07:04 $

if nargin==1
	D=sweepset;
	if T.DataLink ~= 0
		D= sweepset(T.DataLink.info);
	end
else
    error('don''t do this now')
	if ischar(newDL) & strcmp(newDL,'sweepsetfilter')
		D= T.DataLink;
	else
		T.DataLink= newDL;
		pointer(T);
		D= T;
	end
end
	