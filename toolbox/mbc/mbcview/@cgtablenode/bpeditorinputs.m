function [SFnode,OK] = bpeditorinputs(node)
%BPEDITORINPUTS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:29:35 $

% If we're a cgfeattblnode then we have a subfeature, we thus use it.
% OK tells us if we should use this node.

SFnode = [];
OK = 1;

return