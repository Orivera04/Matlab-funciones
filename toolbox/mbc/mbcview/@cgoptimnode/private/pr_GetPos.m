function pos = pr_GetPos(name, allnames);
% PR_GETPOS
%   Find the position of name in the list allnames

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:27:37 $

pos = [];
for i = 1:length(allnames)
    if strmatch(name, allnames{i}, 'exact')
        pos = i;
    end
end
