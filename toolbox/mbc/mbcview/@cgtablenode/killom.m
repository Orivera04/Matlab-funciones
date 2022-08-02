function node = killom(node)
%KILLOM

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:29:51 $

man  = get(node, 'Managers');
man.InitialisationManager = [];
man.FillManager = [];
man.OptimisationManager = [];
node = set(node, 'Managers',man);