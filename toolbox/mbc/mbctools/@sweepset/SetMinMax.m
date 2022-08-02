function T=SetMinMax(S)
% SWEEPSET/SETMINMAX sets min and max for each variable in sweepset
%
% recalculates the minimum and maximum for sweep ignoring bad data.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 08:05:58 $



T=S;
if isempty(S.data)
	return
end
if size(S.data, 1) == 1
	mind=num2cell(S.data);
	maxd=num2cell(S.data);
else
	mind=num2cell(nanmin(S.data));
	maxd=num2cell(nanmax(S.data));
end


[T.var.min]=deal(mind{:});
[T.var.max]=deal(maxd{:});
