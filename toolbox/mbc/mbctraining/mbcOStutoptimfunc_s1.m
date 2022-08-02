function out = mbcOStutoptimfunc_s1(action, in)
%MBCOSTUTOPTIMFUNC_S1 CAGE Optimization Tutorial - Optimization Function
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.1 $    $Date: 2004/02/09 08:21:22 $ 

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
    
    %
    % Put optimization algorithm here
    %
    
    out = optimstore;
    
else
    error('Incorrect action type specified');
end

