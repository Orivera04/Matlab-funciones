function EvM = evalbuild(m,sys)
% MODEL/EVALBUILD build a simulink block to evaluate model

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:51:47 $

% This function will build a simulink block to evaluate
% the model. It returns a handle to the block

try
   ClassStr=class(m);
   EvalStr=['models/',ClassStr];
   EvM=add_block(EvalStr,[sys,'/',ClassStr]);
   
   % break library link
   set_param(EvM,'linkstatus','none');
catch
   error('no appropriate evaluation block found. Make sure model has an appropriate method');
end
