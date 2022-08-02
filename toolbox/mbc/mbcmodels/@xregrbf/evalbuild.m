function Blk = evalbuild(m,sys)
% rbf evalbuild method adds an evaluation simulink block to
% a simulink implementation of a global model

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:54:34 $

% Get data to add to mask


lib  = 'models2/TwoStage/';

switch func2str(m.kernel)
    case 'gaussian'
        evalBlk = [ lib 'rbfGaussianEval' ];
    case 'multiquadric'
        if numel( m.width ) == 1,
            evalBlk = [ lib 'rbfMqGlobalWidthEval' ];
        else
            evalBlk = [ lib 'rbfMultiquadricEval' ];
        end
    case 'recmultiquadric'
        if numel( m.width ) == 1,
            evalBlk = [ lib 'rbfRecmqGlobalWidthEval' ];
        else
            evalBlk = [ lib 'rbfRecmultiquadricEval' ];
        end
    case 'logisticrbf'
        evalBlk = [ lib 'rbfLogisticEval' ];
    case 'thinplate'
        evalBlk = [ lib 'rbfThinplateEval' ];
    case 'wendland'
        evalBlk = [ lib 'rbfWendlandEval' ];	
    case 'linearrbf'
        evalBlk = [ lib 'rbfLinearEval' ];	
    case 'cubicrbf'
        evalBlk = [ lib 'rbfCubicEval' ];	
    otherwise
        error('Unsupported RBF type');
end

Blk = add_block(evalBlk, [sys '/rbf' func2str(m.kernel) 'Eval']);

% break library link
set_param(Blk,'linkstatus','none');
