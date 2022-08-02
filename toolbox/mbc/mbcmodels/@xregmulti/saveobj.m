function m= saveobj(m);
% XREGMULTI/SAVEOBJ

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:54:07 $

m.xregmodel= saveobj(m.xregmodel);
for i=1:length(m.models)
	m.models{i}= saveobj(m.models{i});
end