function node = saveobj(node)
%SAVEOBJ

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:29:54 $

% CGNORMNODE/SAVEOBJ - strips out managers prior to saving.

node.Managers.FillManager = [];
node.Managers.InitialisationManager = [];
node.Managers.OptimisationManager = [];
node.Data = [];
node.InversionData = [];

node.cgcontainer = saveobj(node.cgcontainer);

return