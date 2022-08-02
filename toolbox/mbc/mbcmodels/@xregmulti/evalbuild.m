function Blk = evalbuild(m,sys)
% evalbuild method adds an evaluation simulink block to
% a simulink implementation of a model

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:54:01 $

selectedModel = get(m, 'currentModel');

selectedModel = copymodel(m, selectedModel);

Blk = evalbuild(selectedModel, sys);