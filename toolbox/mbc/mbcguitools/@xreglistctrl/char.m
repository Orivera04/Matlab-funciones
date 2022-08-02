function out = char(obj)
%% xreglistctrl/CHAR returns string 'varname: vals'

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:32:04 $

controls = get(obj,'controls');
out = {};
for i=1:length(controls)
	out = {out{:}, char(controls{i})};
end
