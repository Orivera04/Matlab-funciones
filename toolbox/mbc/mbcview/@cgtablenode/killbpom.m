function node = killbpom(node)
%KILLBPOM

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:29:50 $

% Kills bp optimmanagers for a table node

ch = children(node);

for i = 1:length(ch)
    ch(i).info = killbpom(ch(i).info);
end

return