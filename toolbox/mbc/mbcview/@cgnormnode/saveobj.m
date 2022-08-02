function node = saveobj(node)
%SAVEOBJ

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:25:43 $

% CGNORMNODE/SAVEOBJ - strips out managers prior to saving.

node.Managers.AutoSpaceManager = [];
node.Managers.InitialisationManager = [];
node.Managers.OptimisationManager = [];
node.Data = [];
node.SFData = [];

node.cgcontainer = saveobj(node.cgcontainer);

return