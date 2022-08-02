function out = mbcOSfmincon(action, in)
%MBCOSFMINCON CAGE Optimization library function
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.11.6.5 $    $Date: 2004/04/04 03:26:20 $

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
opt = setName(opt, 'foptcon');

% Add a description
opt = setDescription(opt, 'Single objective optimization subject to constraints');

% Set up the free variables
%%%% Any number are allowed %%%%

% Set up the objective functions
%%%% Only one objective is allowed %%%%

% Set up the constraints
%%%% Any number of constraints are allowed %%%%

% Set up the operating point sets
%%%% The default setting, 0 or 1 is used %%%%

% Set up the optimization parameters
options = xregoptmgr(@omfmincon,cgoptimstore);
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
ub = get(optimstore,'UB');
A = get(optimstore,'A');
B = get(optimstore,'B');

% Get the start conditions for the free variables
x0 = getInitFreeVal(optimstore);
nfreeVariables = size(x0, 2);

objectivesums = get(optimstore, 'objectivesums');
constraintsums = get(optimstore, 'constraintsums');

om = getParam(optimstore, 'Options');
% Set up fmincon Options
if ~isempty(objectivesums)
    set(om,'gradobj','on');
    set(om,'gradconstr', 'on');
end

options = i_fmincon_om2options(om);

options = optimset(options, 'LargeScale','off'); % switch off large scale as we have no gradient information

% Initialise the output structure
OUTPUT(nrowsData).iterations = [];
OUTPUT(nrowsData).funcCount = [];
OUTPUT(nrowsData).stepsize = [];
OUTPUT(nrowsData).algorithm = [];
OUTPUT(nrowsData).firstorderopt = [];
OUTPUT(nrowsData).cgiterations = [];
OUTPUT(nrowsData).message = [];

DLGTITLE = 'foptcon (Single Objective) Optimization';
if isempty(objectivesums) && isempty(constraintsums)
    % for every point in the data set apply fmincon
    DOWAITBAR = (nrowsData > 1);
    if DOWAITBAR
        waitH = xregGui.waitdlg('title',DLGTITLE,'message','');
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
            [bestx(i,:), notused1, notused2, OUTPUT(i)] = fmincon(@i_evalObj, x0(i, :), A, B, [],[], lb, ub, @i_evalCon, options, optimstore, i);
            if DOWAITBAR
                waitH.waitbar.value = i;
            end
        end
        delete(waitH);
    catch
        delete(waitH);
        rethrow(lasterror);
    end

else % must do a single fmincon

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

    try
        waitH = xregGui.msgdlg('title', DLGTITLE, 'message', 'Optimizing... Please wait.');
        objfuncindex = 1;
        [X, notused1, notused2, OUTPUT] = fmincon(@i_evalObjSum, x0, A, B, [],[], lb, ub, @i_evalConSum, options, objfuncindex, pSumSt);
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
    Xmat = reshape(X, nNzt, nfreeVariables);
    bestx = zeros(nrowsData, nfreeVariables);
    bestx(nzt, :) = Xmat;

end

% set the best values calculated for the free variable(s) into the output data set
optimstore = setFreeVariables(optimstore, bestx);

% return OK = 1 if everything went OK
OK = 1;
% Update error message
errormessage = '';

% Set all information in the optimstore, and leave ....
% OK, output, errormessage
optimstore = setOutputInfo(optimstore, OK, errormessage, OUTPUT);

% user defined subfunctions
%------------------------------------------------------------------
function y = i_evalObj(x,optimstore, i)
%------------------------------------------------------------------
y = evaluate(optimstore, x, {'Objective1'},'OperatingPointSet1', i);

ObjectiveFuncTypes = get(optimstore, 'ObjectiveFuncTypes');

switch ObjectiveFuncTypes{1}
    case 'max' % apply fmincon to the negative of the function to be maximimzed
        y = -y;
    case 'min' % no change
    otherwise
        error('This optimization routine can only deal with objective functions to be maximimized or minimized')
end

%------------------------------------------------------------------
function [y, yeq] = i_evalCon(x,optimstore, i)
%------------------------------------------------------------------
% nonlinear inequality constraint
constraints = get(optimstore, 'nonlinearconstraints');

% evaltype is 'dist' so this will give the distance from the constraint
% need y <= 0

if ~isempty(constraints)
    y = evaluate(optimstore, x, constraints,'OperatingPointSet1', i);
else
    y = [];
end

% no nonlinear equality constraints
yeq = [];


%------------------------------------------------------------------
function options = i_fmincon_om2options(om)
%------------------------------------------------------------------
% Convert an om to an fmincon options structure
options = fmincon('defaults');

options= optimset(options, ...
    'Display', get(om ,'Display'),...
    'GradObj',get(om ,'GradObj'),...
    'GradConstr',get(om ,'GradConstr'),...
    'MaxFunEvals',get(om ,'MaxFunEvals'),...
    'MaxIter',get(om ,'MaxIter'),...
    'TolFun', get(om ,'TolFun'),...
    'TolX', get(om ,'TolX'),...
    'TolCon', get(om ,'TolCon'));


%------------------------------------------------------------------
function [ysum, g] = i_evalObjSum(x,funcindex,pSumSt)
%------------------------------------------------------------------

[pSumSt.info, ysum, g] = evalObj(pSumSt.info, x, funcindex);

%------------------------------------------------------------------
function [ysum, yeq, ygci, ygce] = i_evalConSum(x,funcindex,pSumSt)
%------------------------------------------------------------------

[pSumSt.info, ysum, yeq, ygci, ygce] = evalCon(pSumSt.info, x);
