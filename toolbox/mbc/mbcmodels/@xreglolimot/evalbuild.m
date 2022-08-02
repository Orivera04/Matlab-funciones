function Blk = evalbuild(m,sys)
% xreglolimot evalbuild method adds an evaluation simulink block to
% a simulink implementation of a global model

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.6.1 $  $Date: 2004/02/09 07:50:35 $

lib  = 'models2/TwoStage/';
kernel = get(m, 'kernel');

switch kernel
case 'gaussian'
	evalBlk = [ lib 'lolimotGaussianEval' ];
case 'multiquadric'
	evalBlk = [ lib 'lolimotMultiquadricEval' ];
case 'recmultiquadric'
	evalBlk = [ lib 'lolimotRecmultiquadricEval' ];
case 'logisticrbf'
	evalBlk = [ lib 'lolimotLogisticEval' ];
case 'thinplate'
	evalBlk = [ lib 'lolimotThinplateEval' ];
case 'wendland'
	evalBlk = [ lib 'lolimotWendlandEval' ];	
otherwise
    close_system('models2');
	error('Unsupported LOLIMOT type');
end

Blk = add_block( evalBlk, [sys '/lolimot' kernel 'Eval'] );

% break library link
set_param(Blk,'linkstatus','none');

% Find the betaModel_x2fx block
x2fxBlock = find_system( Blk, 'lookundermasks', 'all', ...
    'name', 'betaModel_x2fx' );
x2fxBlockName = [ get_param(x2fxBlock, 'parent') '/' get_param(x2fxBlock, 'name') ];
set_param(x2fxBlock,'linkstatus','none');

% Add the correct kernel
switch class( m.betamodels{1} ),
case 'xreglinear',
    x2fxEvalPathToAdd = 'models2/TwoStageJacob';
    x2fxEvalBlockToAdd = 'xreglinear_x2fx';
case 'xregcubic'
    x2fxEvalPathToAdd = 'models2/TwoStageJacob/mvcubicJacob';
    x2fxEvalBlockToAdd = 'mvCubicEval';
otherwise
    error( 'Unspported beta model class' );
end
x2fxEvalBlock = add_block( [ x2fxEvalPathToAdd '/' x2fxEvalBlockToAdd ], ...
    [ x2fxBlockName '/' x2fxEvalBlockToAdd ] );
x2fxEvalBlockName = get_param( x2fxEvalBlock, 'name' );

% Wire up its input and output
add_line( x2fxBlock, 'x/1', [x2fxEvalBlockName, '/1']);  
add_line( x2fxBlock, [x2fxEvalBlockName, '/1'], 'fx/1');

set_param( x2fxEvalBlock, 'Position', [160    50   310   175] );
