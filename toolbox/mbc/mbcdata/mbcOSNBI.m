function out = mbcOSNBI(action, in)
% MBCOSNBI CAGE Optimization library function
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.14.6.5 $    $Date: 2004/04/04 03:26:19 $

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
opt = setName(opt, 'NBI');

% Add a description
opt = setDescription(opt, 'Normal Boundary Intersection Algorithm');

% Set up the free variables
%%%% Any number are allowed %%%%

% Set up the objective functions
opt = setObjectivesMode(opt, 'multiple');

% Set up the constraints
%%%% Any number of constraints are allowed %%%%

% Set up the operating point sets
%%%% The default setting, 0 or 1 is used %%%%

% Set up the optimization parameters
options = xregoptmgr(@omnbi,cgoptimstore);
opt = addParameter(opt, options);

%---------------------------------------------------------------
function optimstore = i_Evaluate(optimstore)
%------------------------------------------------------------------

% Optimization routine must conform to the following API
% optimstore = <OPTIMIZATION_FUNCTION>(optimstore)
%
% Inputs: optimstore: store of all the CAGE data needed
% Outputs: optimstore: updated object containing all the CAGE data, including outputs
%

% get information from the dataset
nrowsData = getNumRowsInDataset(optimstore, 'OperatingPointSet1');

lb = get(optimstore,'LB');
ub =  get(optimstore,'UB');
A = get(optimstore,'A');
B = get(optimstore,'B');

NumberOfObjectives = get(optimstore, 'NumObjectiveFuncs');
% Get the start conditions for the free variables
x0 = getInitFreeVal(optimstore);
nfreeVariables = size(x0,2);
NumberOfPoints = getParam(optimstore, 'NumberOfPoints');

objectivesums = get(optimstore, 'objectivesums');
constraintsums = get(optimstore, 'constraintsums');

% Set up NBI Options
omNBI = getParam(optimstore, 'Options');
if ~isempty(objectivesums)
    set(omNBI,'ShadowOptions.gradobj','on');
    set(omNBI,'ShadowOptions.gradconstr', 'on');
    set(omNBI,'NBISubproblemOptions.gradconstr', 'on');
end
NBIoptions = cgnbiom2options(omNBI);

NumberOfOutputs = nchoosek(NumberOfObjectives + NumberOfPoints-2,NumberOfPoints-1);
bestx = zeros(nrowsData, nfreeVariables, NumberOfOutputs);

% Initialise the output structure
OUTPUT(nrowsData).shadowIterations = [];
OUTPUT(nrowsData).shadowFuncCount = [];
OUTPUT(nrowsData).numberNBISubproblems = [];
OUTPUT(nrowsData).NBISubproblemIterations = [];
OUTPUT(nrowsData).NBISubproblemFuncCount = [];

DLGTITLE = 'NBI (Multi-Objective) Optimization';
if isempty(objectivesums) && isempty(constraintsums)
    % for every point in the data set apply NBI
    DOWAITBAR = (nrowsData > 1);
    if DOWAITBAR
        waitH = xregGui.waitdlg('title', DLGTITLE, 'message', 'Computing optimal settings for operating point 1.');
        waitH.waitbar.min = 0;
        waitH.waitbar.max = nrowsData;
    else
        waitH = xregGui.msgdlg('title', DLGTITLE, 'message', 'Optimizing... Please wait.');
    end
    try
        for i =1:nrowsData
            if DOWAITBAR
                waitH.message = sprintf('Computing optimal settings for operating point %d...',i);
            end
            [Xmat,Fmat,EXITFLAG,OUTPUT(i)] = cgnbi(@i_evalObj,x0(i, :)',NumberOfObjectives, NumberOfPoints,A,B,[], [], lb', ub', @i_evalCon, NBIoptions,optimstore, i);
            bestx(i,:,:) = Xmat;
            if DOWAITBAR
                waitH.waitbar.value = i;
            end
        end
        delete(waitH);
    catch
        delete(waitH);
        rethrow(lasterror);
    end


else % must do a single NBI

    %
    % Now use the cgsumstore utility object to get inputs in correct form
    % to pass to optimizer
    %
    sumst = cgsumstore(optimstore, true, true);
    % Reshaped initial conditions
    x0 = getInitVals(sumst);
    % Reshaped linear constraints
    [A, B] = getLinCon(sumst);
    % Reshaped bounds
    [lb, ub] = getBounds(sumst);
    % Create a pointer to hold the sum store object
    pSumSt = xregGui.RunTimePointer;
    pSumSt.info = sumst;

    %
    % Optimize
    %
    waitH = xregGui.msgdlg('title', DLGTITLE, 'message', 'Optimizing... Please wait.');
    try
        [Xmat,Fmat,EXITFLAG, OUTPUT] = cgnbi(@i_evalObjSum, x0,NumberOfObjectives, NumberOfPoints, A, B, [],[], lb, ub, @i_evalConSum, NBIoptions, pSumSt);
        delete(waitH);
    catch
        delete(waitH);
        rethrow(lasterror);
    end

    %
    % Write output
    %
    nzt = getNonZeroWtPts(pSumSt.info);
    nNzt = length(nzt);
    Xmat = reshape(Xmat, nNzt, nfreeVariables, NumberOfOutputs);
    bestx = zeros(nrowsData, nfreeVariables, NumberOfOutputs);
    bestx(nzt, :, :) = Xmat;

end

% set the best values calculated for the free variable(s) into the output data set
optimstore = setFreeVariables(optimstore, bestx);

% return OK = 1 if everything went OK
OK = 1;
errormessage = '';

% Set all information in the optimstore, and leave ....
% OK, output, errormessage
optimstore = setOutputInfo(optimstore, OK, errormessage, OUTPUT);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% internal subroutines called from i_evaluate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%------------------------------------------------------------------
function y = i_evalObjFn(funcindex, x, optimstore, i)
%------------------------------------------------------------------

objectives = cell(1, length(funcindex));
for j = 1:length(funcindex)
    objectives{j} = sprintf('Objective%d', funcindex(j));
end

% evaluate the objectives specified by funcindex
y = evaluate(optimstore, x', objectives,'OperatingPointSet1', i)';

%------------------------------------------------------------------
function y = i_evalObj(x,funcindex, optimstore, i)
%------------------------------------------------------------------

% evaluate the objectives specified by funcindex
y = i_evalObjFn(funcindex, x, optimstore, i);

ObjectiveFuncTypes = get(optimstore, 'ObjectiveFuncTypes');
for j = 1:length(funcindex)
    switch ObjectiveFuncTypes{funcindex(j)}
        case 'max' % use negative of the function
            y(j,:) = -y(j,:);
        case 'min' % no change
        otherwise
            error('This optimization routine can only deal with objective functions to be maximimized or minimized')
    end
end


%------------------------------------------------------------------
function [y, yeq] = i_evalCon(x,funcindex, optimstore, i)
%------------------------------------------------------------------

% nonlinear inequality constraint
constraints = get(optimstore, 'nonlinearconstraints');

% evaltype is 'dist' so this will give the distance from the constraint
% need y <= 0

if ~isempty(constraints)
    y = evaluate(optimstore, x', constraints,'OperatingPointSet1', i);
else
    y = [];
end

% no nonlinear equality constraints
yeq = [];


%------------------------------------------------------------------
function [ysum, g] = i_evalObjSum(x,funcindex,pSumSt)
%------------------------------------------------------------------

[pSumSt.info, ysum, g] = evalObj(pSumSt.info, x, funcindex);

%------------------------------------------------------------------
function [ysum, yeq, ygci, ygce] = i_evalConSum(x,funcindex,pSumSt)
%------------------------------------------------------------------

[pSumSt.info, ysum, yeq, ygci, ygce] = evalCon(pSumSt.info, x);

