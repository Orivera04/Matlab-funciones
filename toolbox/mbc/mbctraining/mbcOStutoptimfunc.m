function out = mbcOStutoptimfunc(action, in)
%MBCOSTUTOPTIMFUNC CAGE Optimization Tutorial - Optimization Function
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.4 $    $Date: 2004/04/04 03:32:57 $ 

% Deal with the action inputs
if strcmp(action, 'options')

    options = in;
    % Add a name
    options = setName(options, 'Tutorial_Optimization');
    
    % Add a description
    options = setDescription(options, 'A simple worked example to maximize torque');
    
    % Set up the free variables
    options = setFreeVariablesMode(options, 'fixed');
    options = addFreeVariable(options, 'afr');
    options = addFreeVariable(options, 'spk');
    
    % Set up the objective functions
    options = setObjectivesMode(options, 'fixed');
    options = addObjective(options, 'Torque', 'max');
    
    % Set up the constraints
    options = setConstraintsMode(options, 'fixed');
    % There are no constraints for this example
    
    % Set up the operating point sets
    options = setOperatingPointsMode(options, 'fixed');
    options = addOperatingPointSet(options, 'SpeedLoadPoints', {'speed', 'load'});
    
    % Set up the optimization parameters
    options = addParameter(options, 'Resolution', 'number', 25);

    out= options;
elseif strcmp(action, 'evaluate')
    optimstore = in;
    optimstore = tutoptimizer(optimstore);
    out = optimstore;
else
    error('Incorrect action type specified');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function optimstore = tutoptimizer(optimstore)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TUTOPTIMIZER CAGE Optimization Tutorial 
%               Optimization function that can be read by CAGE

% Number of rows in the operating point set...
no_of_speed_load_points = getNumRowsInDataset(optimstore, 'SpeedLoadPoints'); 

% Get the start conditions for the free variables
x0 = getInitFreeVal(optimstore);
nfreeVariables = size(x0, 2);

% Create an options structure for fminunc
algoptions = optimset('LargeScale', 'off', 'Display', 'off');

% Do the optimization 
waitH = waitbar(0,'','name','Tutorial Optimization');
for i = 1:no_of_speed_load_points
    waitbar((i-1)/no_of_speed_load_points,waitH, ['Computing optimal settings for operating point ' num2str(i)]);    
    [bestx(i, :), notused1, notused2] = fminunc(@trqfunc_new, x0(i, :), algoptions,optimstore, i);
end
    
% End Optimization
waitbar(1,waitH, 'Optimization completed');
close(waitH);

% Write output info to optimstore
% Set the best values calculated for the free variable(s) into the output data set
optimstore = setFreeVariables(optimstore, bestx);

% return OK = 1 if everything went OK
OK = 1;
% Update error message
errormessage = '';

% OK, output, errormessage
optimstore = setOutputInfo(optimstore, OK, errormessage, struct([]));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function y = trqfunc_new(x, optimstore, row_index)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TRQFUNC_NEW Objective function (Torque) for Optimization example
%

y = evaluate(optimstore, x, {'Torque'},'SpeedLoadPoints', row_index);
y = -y;
