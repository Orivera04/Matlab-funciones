function m= saveobj(m);
% XREGTWOSTAGE/SAVEOBJ

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:00:13 $

m.xregmodel= saveobj(m.xregmodel);
for i=1:length(m.Global)
	m.Global{i}= saveobj(m.Global{i});
end
if isa(m.datum,'xregmodel');
	m.datum= saveobj(m.datum);
end
m.Local= saveobj(m.Local);
	