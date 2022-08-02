function yi= yinfo(TS,yi);
% XREGTWOSTAGE/YINFO

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:00:23 $

if nargin==1
	yi= yinfo(TS.xregmodel);
else
	TS.xregmodel= yinfo(TS.xregmodel,yi);
	TS.Local= yinfo(TS.Local,yi);
	yi= TS;
end