function Blk = evalbuild(m,sys)
% TRUNCPS/EVALBUILD - adds the simulink 'model eval block'
%
% evalbuild method adds an evaluation simulink block to
% a simulink implementation of a model

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:42:58 $


%error('not defined yet')
Blk= add_block('models2/LocalMod/truncpsEval',[sys,'/truncpsEval']);

% break library link
set_param(Blk,'linkstatus','none');

