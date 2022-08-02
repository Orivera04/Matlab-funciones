function m= reset(m);
% XREGTWOSTAGE/RESET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 08:00:12 $

for i=1:length(m.Global);
	m.Global{i}= reset(m.Global{i});
end
if isa(m.datum,'xregmodel')
	m.datum= reset(m.datum);
end
m.xregmodel= reset(m.xregmodel);