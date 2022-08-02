function OK= checkmodel(TS)
% XREGTWOSTAGE/CHECKMODEL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.



%   $Revision: 1.8.2.2 $  $Date: 2004/02/09 07:59:22 $

OK= checkmodel(TS.Local);

for i=1:length(TS.Global)
	OK= checkmodel(TS.Global{i});
end

if isa(TS.datum,'xregmodel')
	OK= checkmodel(TS.datum);
end
