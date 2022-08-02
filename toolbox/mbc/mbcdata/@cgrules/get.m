function out = get(rules,ind,property)
%GET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:55:21 $

out = [];
switch lower(property)
case 'state'
    if ~rules.enable(ind)
        out = 0;
    elseif rules.exclude(ind)
        out = -1;
    else
        out = 1;
    end
end