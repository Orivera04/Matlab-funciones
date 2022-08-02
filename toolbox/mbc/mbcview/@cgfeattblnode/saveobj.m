function node = saveobj(node)
%SAVEOBJ

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:24:01 $

% CGNORMNODE/SAVEOBJ - strips out managers prior to saving.

node.SFData = [];

node.cgtablenode = saveobj(node.cgtablenode);

return