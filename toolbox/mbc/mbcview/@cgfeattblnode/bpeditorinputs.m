function [SFnode,OK] = bpeditorinputs(node)
%BPEDITORINPUTS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:23:54 $

% If we're a cgfeattblnode then we have a subfeature, we thus use it.

SFnode = Parent(node);
OK = 1;

return
