function [obj, ok, report] = setupfromscript(obj, action)
%SETUPFROMSCRIPT Set up optimization options from the script
%
%  [OBJ, OK, REPORT] = SETUPFROMSCRIPT(OBJ) runs the optimization script to
%  get the information required to set up the optimization object.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.12.6.2 $    $Date: 2004/02/09 06:54:00 $ 

if nargin > 1
    obj = @i_Evaluate;
    return;
end

report = '';
ok = true;

% 1. Ensure optimization has a filename and can be run
fname = obj.fname;
if isempty(fname)
    ok = false;
    report = {'No optimization function', 'Optimization object contains no function name.'}';
    return
end

% 2. Find the file on the path
fcell = which(fname, '-all');
if isempty(fcell)
    ok = false;
    str2 = ['Cannot find file ', fname, ' on the path'];
    report = {'File location error', str2};
    return;
end

% 3. Use the MATLAB debugger to parse the file
try 
   dbstop('in', fname);
   dbclear('in', fname);
catch
   ok = false;
   report = {'Syntax error', ['Optimization function, ' fname, ', contains an invalid MATLAB command. MATLAB error message ...', char(10), char(10),lasterr]};
   return;
end

% 4. Retrieve the user options
% This tests the interface opt = <user_file>('options', opt)
try
    options = cgoptimoptions;
    options = feval(fname, 'options', options);
catch
    ok = false;
    report = {'Error during testing', lasterr};
    return;
end
if ~isa(options, 'cgoptimoptions')
    ok = false;
    report = {'Error during testing', ['The call opt = ', fname, '(''options'', opt) must return the optimization options']};
    return;
end

% 5. Test the evaluation routine interface
% Interface to test here:
% optimstore = feval(function_handle, optimstore)
% Any errors here will have to be picked up at runtime

% 6. Copy the user settings into cgoptim
obj = i_OptionsToOptim(options, obj, fname);

%--------------------------------------------------------------------------
function optim = i_OptionsToOptim(options, optim, fname)
%--------------------------------------------------------------------------

% Note, this function contains NO error checking

% General
optim.name = getName(options);

optim.description = getDescription(options);
optim_params = getParameters(options);
if isstruct(optim_params)
    for i = 1:length(optim_params)
        if strcmp(optim_params(i).typestr, 'list')
            % Need to regenerate the list string
            listcell = optim_params(i).value;
            liststr = '';
            for j = 1:length(listcell)
                liststr = [liststr, listcell{j}, '|'];
            end
            optim_params(i).value = liststr(1:end-1);
        end
        newoptim_params{i} = {optim_params(i).typestr, optim_params(i).label, optim_params(i).value};
    end
    optim_params = newoptim_params;
else
    % We're passing in an optim mgr
end

optim.om = createom(xregoptmgr, cgoptimstore, @i_Evaluate, optim.name, optim_params);

% Free Variables
freevarmode = getFreeVariablesMode(options);
switch freevarmode
    case 'fixed'
        optim.canaddvalues = 0;
    case 'any'
        optim.canaddvalues = 1;
end
freevar = getFreeVariables(options);
if isempty(freevar)
    optim.valueLabels = {};
else
    optim.valueLabels = freevar;
end
% create dummy xregpointers for cage variables
for i = 1:length(optim.valueLabels)
    optim.values = [optim.values xregpointer];
end

% Objectives
objmode = getObjectivesMode(options);
optim_objective = getObjectives(options);
optim.objectiveFuncs = [];
optim.objectiveFuncLabels = [];
% Do we support the 'anynumber' flag for objectives ?
switch objmode
    case 'fixed'
        optim.canaddobjectiveFuncs = 0;
    case 'any'
        optim.canaddobjectiveFuncs = 1;
    case 'multiple'
        optim.canaddobjectiveFuncs = 2;
end   
for i=1:size(optim_objective, 2)
    entry = optim_objective(i);
    objective_name = entry.label;
    objective_type = entry.type;    
    switch objective_type
        case {'min', 'max', 'helper', 'neither'}
            canswitchminmax = 0;
        case {'min/max'}
            objective_type = 'min';
            canswitchminmax = 1;
    end
    optim.objectiveFuncLabels{i} = objective_name;
    optim.objectiveFuncs = [optim.objectiveFuncs xregpointer(cgobjectivefunc(objective_name, objective_type, canswitchminmax))];       
end

% Constraints
constraints_modify = getConstraintsMode(options);
constraint_entries = i_getConstraints(options);
optim.constraints = [];
optim.constraintLabels = [];
switch constraints_modify
    case 'fixed'
        optim.canaddconstraints = 0;
    case 'any'
        optim.canaddconstraints = 1;
end
for i=1:length(constraint_entries)
    entry = constraint_entries(i);
    constraint_name = entry.label;
    constraint_type = entry.typestr;
    constraint_parms = entry.pars;
    switch(lower(constraint_type))
        case 'model'
            % create the conmod which will be wrapped by an xregpointer
            conobj = concgmodel(length(optim.values), constraint_parms{:});
        case '1dtable'
            % create the conmod which will be wrapped by an xregpointer
            conobj = contable1(length(optim.values), constraint_parms{:});
        case '2dtable'
            % create the conmod which will be wrapped by an xregpointer
            conobj = contable2(length(optim.values), constraint_parms{:});
        case 'linear'
            % create the conmod which will be wrapped by an xregpointer
            conobj = conlinear(length(optim.values), constraint_parms{:});
        case 'ellipsoid'
            % create the conmod which will be wrapped by an xregpointer
            conobj = conellipsoid(length(optim.values), constraint_parms{:});
    end
    constraint = cgconstraint(constraint_name, conobj, optim.values, 'dist');
    optim.constraintLabels{i} = constraint_name;
    optim.constraints = [optim.constraints xregpointer(constraint)];
end

% Data Sets
dataset_type = getOperatingPointsMode(options);
dataset_fields = getOperatingPointSets(options);
  switch dataset_type
    case 'fixed'
        optim.canaddoppoints = 0;
    case 'any'
        optim.canaddoppoints = 1;
    case 'default'
        optim.canaddoppoints = 2;
end
    
optim.oppointLabels = {};
optim.oppointValueLabels = {};
for i=1:length(dataset_fields)
    optim.oppointLabels{i} = dataset_fields(i).label;
    optim.oppointValueLabels{i} = dataset_fields(i).vars;
end
    
%fill oppointvalues with null pointers
for i = 1:length(optim.oppointLabels)
    optim.oppointValues{i} = [];
    for j = 1:length(optim.oppointValueLabels{i})
        optim.oppointValues{i} = [optim.oppointValues{i} xregpointer];
    end
end
    
%oppoints
L=length(optim.oppointLabels);
if L
    optim.oppoints=assign(xregpointer,zeros(1,L));
else
    optim.oppoints=[];
end      

%enabled flag
optim.isenabled = getEnabled(options);

%--------------------------------------------------------------------------
function [optimstore, cost, OK] = i_Evaluate(optimstore, om, x0, fname)
%--------------------------------------------------------------------------

% This is a wrapper for the user's Evaluation routine

optimstore = feval(fname, 'evaluate', optimstore);
cost = [];
OK = [];

%--------------------------------------------------------------------------
function coninfo = i_getConstraints(options)
%--------------------------------------------------------------------------

coninfo = [];
modinfo = getModelConstraints(options);
for i = 1:length(modinfo)
    N = length(coninfo) + 1;
    coninfo(N).label = modinfo(i).label;
    coninfo(N).typestr = 'model';
    coninfo(N).pars{1} = 'bound';
    coninfo(N).pars{2} = modinfo(i).bound;
    coninfo(N).pars{3} = 'bound_type';
    switch modinfo(i).boundtype
        case {'lthan', 'lessthan'}
            coninfo(N).pars{4} = 0;
        case {'gthan', 'greaterthan'}
            coninfo(N).pars{4} = 1;
    end
end

lininfo = getLinearConstraints(options);
for i = 1:length(lininfo)
    N = length(coninfo) + 1;
    coninfo(N).label = lininfo(i).label;    
    coninfo(N).typestr = 'linear';
    coninfo(N).pars{1} = 'A';
    coninfo(N).pars{2} = lininfo(i).A;
    coninfo(N).pars{3} = 'b';
    coninfo(N).pars{4} = lininfo(i).b;    
end
