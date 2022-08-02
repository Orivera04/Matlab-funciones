function simSetEvalParam(m,sys)
% evalbuild method adds an evaluation simulink block to
% a simulink implementation of a model

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:54:09 $

selectedModel = get(m, 'currentModel');

selectedModel = copymodel(m, selectedModel);

simSetEvalParam(selectedModel, sys);