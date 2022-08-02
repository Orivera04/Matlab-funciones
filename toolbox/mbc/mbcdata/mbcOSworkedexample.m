function out = mbcOSworkedexample(action, in)
% MBCOSWORKEDEXAMPLE Worked example for CAGE Optimization
%
%  This is an example Optimization script. 
%  See also MBCOSTEMPLATE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.8.6.3 $    $Date: 2004/02/09 06:56:32 $

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Deal with the two action cases
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch lower(action)  
    case 'options'
        % Return the updated options object 
        out = i_Options(in);
    case 'evaluate' 
        % Return a handle to the main evaluation routine
        out = i_Evaluate(in);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% options Function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function opt = i_Options(opt)

% Add a name
opt = setName(opt, 'WorkedExample');

% Add a description
opt = setDescription(opt, 'A simple worked example to maximize torque');

% Set up the free variables
opt = setFreeVariablesMode(opt, 'fixed');
opt = addFreeVariable(opt, 'afr');
opt = addFreeVariable(opt, 'spk');

% Set up the objective functions
opt = setObjectivesMode(opt, 'fixed');
opt = addObjective(opt, 'Torque', 'max');

% Set up the constraints
opt = setConstraintsMode(opt, 'fixed');
% There are no constraints for this example

% Set up the operating point sets
opt = setOperatingPointsMode(opt, 'fixed');
opt = addOperatingPointSet(opt, 'SpeedLoadPoints', {'EngSpeed', 'Load'});

% Set up the optimization parameters
opt = addParameter(opt, 'Resolution', 'number', 25);

%---------------------------------------------------------------
function optimstore = i_Evaluate(optimstore)
%------------------------------------------------------------------

% Optimization routine must conform to the following API
% optimstore = <OPTIMIZATION_FUNCTION>(optimstore)
%
% Inputs: optimstore: store of all the CAGE data needed
% Outputs: optimstore: updated object containing all the CAGE data, including outputs
% 

OK = 1;
errormessage = '';

% Here, get the initial values if reqd from the optimstore...

% Get the ranges for SPK and AFR
lb = get(optimstore,'LB');
ub =  get(optimstore,'UB');
minAFR = lb(1);
maxAFR = ub(1);
minSPK = lb(2);
maxSPK = ub(2);

res=getParam(optimstore, 'Resolution');

% get the (N, L) points we want to perform the optimization at
speedloadpts = getDataset(optimstore, {'EngSpeed', 'Load'}, 'SpeedLoadPoints'); 

% For every (speed, load) point, find the optimum (afr, spk) using
% the mbcweoptimizer routine you have written
waitH = waitbar(0, 'Starting Optimizer', 'name', 'CAGE Worked Example Optimization');
bestafr = zeros(size(speedloadpts,1), 1);
bestspk = zeros(size(speedloadpts,1), 1);
for i =1:size(speedloadpts,1)
    waitbar(i/size(speedloadpts, 1),waitH,['Optimizing Point: Speed = ', num2str(speedloadpts(i, 1)), ' ,Load = ',num2str(speedloadpts(i, 2)) ]);
    [thisbestafr, thisbestspk] = mbcweoptimizer(@i_evalTQ, speedloadpts(i, 1), speedloadpts(i, 2), [minAFR, maxAFR], [minSPK, maxSPK], res, optimstore); 
    bestafr(i) = thisbestafr;
    bestspk(i) = thisbestspk;
end
delete(waitH);
% set the best values calculated for the free variable(s) into the output data set
optimstore = setFreeVariables(optimstore, [bestafr, bestspk]);

% return OK = 1 if everything went OK
OK = 1;
% return a measure of the goodness of optimization if required
OUTPUT.Algorithm = 'Brute force search';
% Update error message
errormessage = '';

% Set all information in the optimstore, and leave ....
% OK, output, errormessage
optimstore = setOutputInfo(optimstore, OK, errormessage, OUTPUT);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% internal subroutines called from i_evaluate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%------------------------------------------------------------------
function y = i_evalTQ(afr, spk, speed, load, optimstore)
%------------------------------------------------------------------

speedloadpts = getDataset(optimstore, {'EngSpeed', 'Load'}, 'SpeedLoadPoints'); 
% Find where the current speed, load point is in the speedloadpoints dataset
current_speedloadpt = [];
for i = 1:size(speedloadpts, 1)
   if isequal([speed, load], speedloadpts(i, :))
      current_speedloadpt = i;
      break;
   end
end
y = gridEvaluate(optimstore, [afr, spk], {'Torque'},'SpeedLoadPoints', current_speedloadpt);




