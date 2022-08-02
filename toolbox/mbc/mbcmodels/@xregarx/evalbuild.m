function Blk = evalbuild(m,sys)
% xregarx evalbuild method adds an evaluation simulink block to
% a simulink implementation of a global model

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.7.6.1 $  $Date: 2004/02/09 07:44:52 $

% Get data to add to mask

lib  = 'models2/TwoStage/rbfUtils/';

shellBlk = [ lib 'arxShellEval' ];
Blk = add_block(shellBlk, [sys '/arxEval']);

% Break library link
set_param(Blk,'linkstatus','none');

% Find the kernel block
kernelBlk = find_system(Blk, 'lookundermasks', 'all', 'name', 'kernel');
kernelBlkName = [ get_param(kernelBlk, 'parent') '/' get_param(kernelBlk, 'name') ];

% Add the correct kernel
kernelEvalBlk = evalbuild(m.StaticModel, kernelBlkName);
kernelEvalBlkName = get_param(kernelEvalBlk, 'name');

set_param(kernelEvalBlk, 'position', [105    45   175   105]);

% Wire up its input
add_line(kernelBlk, 'X/1', [kernelEvalBlkName '/1']);
% Wire up its outputs
add_line(kernelBlk, [kernelEvalBlkName '/1'], 'Y/1');
add_line(kernelBlk, [kernelEvalBlkName '/2'], 'J/1');
