function [obj, hasrun] = autoTradeoff(obj)
%AUTOTRADEOFF Perform an automated trade off
%
%  [OBJ, HASRUN] = AUTOTRADEOFF(OBJ) automatically performs a trade-off
%  using an optimization algorithm selected by the user.  The output HASRUN
%  indicates whether the optimization was completed or whether the user
%  cancelled at some point

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.8.3 $  $Date: 2004/04/04 03:36:25 $

hasrun = false;
pTableInputs = pGetTableInputs(obj);

% Choose an optimization 
[optimnode, ok] = i_ChooseOptimization(obj, pTableInputs);
if ~ok
    return
end

% Ask user how they want to define the points that should be run and return
% the selection as a list of datakeys
OldKeyTable = obj.DataKeyTable;
[obj, datakeys, ok] = i_SelectTradeoffPoints(obj);
if ~ok
    return
elseif length(datakeys)==0
    h = warndlg('There are no table cells defined by your selection.', ...
        'Automated Tradeoff Warning', 'modal');
    waitfor(h);
    return
end
xregpointer(obj);

% Snap all inputs to the selected points
pSetInputsAt(obj, datakeys);

% Set up and run the optimization
[pInputs, data, OK] = i_SetUpandRunOptim(optimnode, pTableInputs);

% Update the tradeoff if the optimization ran successfully
if OK > 0
    % For each optimized point, set the data into the inputs and save the
    % values of all of the tradeoff inputs.  We only need to use the
    % optimized data for inputs that are actually in the tradeoff.
    pAll = [pGetTableInputs(obj), pGetOtherInputs(obj)];
    if ~isempty(pAll)
        DataColumnIndex = findptrs(pAll, pInputs);
        hAll = infoarray(pAll);
        for n = 1:size(data, 1)
            for m = 1:length(hAll)
                if DataColumnIndex(m)>0
                    hAll{m} = setstorevalue(hAll{m}, obj.ObjectKey, ...
                        datakeys(n), data(n, DataColumnIndex(m)));
                else
                    hAll{m} = copyvaluetostore(hAll{m}, obj.ObjectKey, datakeys(n));
                end
            end
        end
        passign(pAll, hAll);
    end
    
    % Mark each of these points as having been saved
    obj.DataKeyTable = incrementSaveCounter(obj.DataKeyTable, datakeys);
    
    % Apply filling action to all of these points that have a table link
    [TableIndex, HasLink] = getTableFromDatakey(obj.DataKeyTable, datakeys);
    pSetInputsAt(obj, datakeys(HasLink));
    done = captureTableFillAt(obj, getTable(obj, 'all'), TableIndex{:});    
    
    xregpointer(obj);
    hasrun = true;
else
    % Restore tradeoff object to initial state.  This will undo any changes
    % to the saved data point list
    obj.DataKeyTable = OldKeyTable;
    xregpointer(obj);
end




%-------------------------------------------------------------------------|
function [obj, datakeys, ok] = i_SelectTradeoffPoints(obj)
%-------------------------------------------------------------------------|

% Pop up a small dialog asking the user which points to run the
% optimisation on.  The user can select:
%
%  (1) Multimodel sites (appears only for multimodels, becomes the default)
%  (2) All table region cells (standard default)
%  (3) All table cells
%  (4) Previously saved tradeoff points (enabled only when there are some)

% Check for multimodels
pTableInfo = getAllTableData(obj);
pMask = pTableInfo(~isnull(pTableInfo(:, 3)), 3);
IsMM = pveceval(pMask, @isSwitchExpr);
IsMM = [IsMM{:}];

% Check for existence of regions in any tables
HasRegion = pveceval(pTableInfo(:,1), @anyExtrapolationRegions);
HasRegion = [HasRegion{:}];

% Check for previous tradeoff points
HasSavedPoints = length(obj.DataKeyTable) > 0;

if any(IsMM)
    opts = {'Valid Multimodel evaluation sites'; ...
        'All table cells that are in a region'; ...
        'All table cells'; ...
        'Previously saved Tradeoff points'};
    DefaultValue = 1;
else
    opts = {'All table cells that are in a region'; ...
        'All table cells'; ...
        'Previously saved Tradeoff points'};
    if any(HasRegion)
        DefaultValue = 1;
    else
        DefaultValue = 2;
    end
end
OptionsEnable = true(size(opts));
if ~HasSavedPoints
    OptionsEnable(end) = false;
end

figh = xregdialog('Name', 'Select Points to Optimize', ...
    'Resize', 'off');
xregcenterfigure(figh, [350 170]);

txt = uicontrol('Parent', figh, ...
    'Style', 'text', ...
    'HorizontalAlignment', 'left', ...
    'String', 'Please select the the set of points that you want to optimize:');
rbg = xregGui.rbgroup('Parent', figh, ...
    'nx', 1, 'ny', length(opts), ...
    'string', opts, ...
    'Selected', DefaultValue, ...
    'EnableArray', OptionsEnable);
hOK = uicontrol('Parent', figh, ...
    'Style', 'pushbutton', ...
    'String', 'OK', ...
    'callback', 'set(gcbf, ''tag'', ''ok'', ''visible'', ''off'');');
hCancel = uicontrol('Parent', figh, ...
    'Style', 'pushbutton', ...
    'String', 'Cancel', ...
    'callback', 'set(gcbf, ''tag'', ''cancel'', ''visible'', ''off'');');

lyt = xreggridbaglayout(figh, ...
    'packstatus', 'off', ...
    'dimension', [4 3], ...
    'rowsizes', [17 20*length(opts) -1 25], ...
    'colsizes', [-1 65 65], ...
    'gapx', 7, ...
    'border', [7 7 7 10], ...
    'mergeblock', {[1 1], [1 3]}, ...
    'mergeblock', {[2 2], [1 3]}, ...
    'elements', {txt, rbg, [],[],[],[],[],hOK, [],[],[],hCancel});
figh.LayoutManager = lyt;
set(lyt, 'packstatus', 'on');

figh.showDialog(hOK);

if strcmp(get(figh, 'tag'), 'ok')
    sel = get(rbg, 'Selected');
    if any(IsMM)
        sel = sel - 1;
    end
    switch sel
        case 0
            [obj, datakeys] = i_getswitchpoints(obj);
        case 1
            [obj, datakeys] = i_getregions(obj);
        case 2
            [obj, datakeys] = i_getalltable(obj);
        case 3
            [obj, datakeys] = i_getcurrent(obj);
    end
    ok = true;
else
    datakeys = [];
    ok = false;
end  
delete(figh);
drawnow('expose');


function [obj, datakeys] = i_getswitchpoints(obj)
if numTables(obj)>0
    pTableData = getAllTableData(obj);
    setInputsAt(obj, 'table', 1, 1);
    OK = pTableData(1,1).setinportsforcells;
    pInp = pGetTableInputs(obj);
    if OK
        msk = false(pTableData(1,1).getTableSize);
        for n = 1:size(pTableData,1)
            if ~isnull(pTableData(n,3)) && pTableData(n,3).isSwitchExpr
                msk = msk | pTableData(n,3).getSwitchGrid(pInp);
            end
        end
        
        [R, C] = find(msk);
        new = ~containsTable(obj.DataKeyTable, R, C);

        % Add data keys for new input settings
        obj.DataKeyTable = addTableDatakeys(obj.DataKeyTable, R(new), C(new));
        
        % Get the datakeys for all cells required
        datakeys = getDatakeyFromTable(obj.DataKeyTable, R, C);
    else
        datakeys = [];
    end
else
    datakeys = [];
end

function [obj, datakeys] = i_getregions(obj)
if numTables(obj)>0
    % Form OR-ed mask from all table regions
    pT = getTable(obj, 'all');
    msk = false(pT(1).getTableSize);
    for n = 1:length(pT)
        msk = msk | pT(n).getExtrapolationRegions;
    end

    [R, C] = find(msk);
    new = ~containsTable(obj.DataKeyTable, R, C);

    % Add data keys for new input settings
    obj.DataKeyTable = addTableDatakeys(obj.DataKeyTable, R(new), C(new));
    
    % Get the datakeys for all cells required
    datakeys = getDatakeyFromTable(obj.DataKeyTable, R, C);
else
    datakeys = [];
end

function [obj, datakeys] = i_getalltable(obj)
if numTables(obj)>0
    sz = obj.Tables(1).getTableSize;
    [R, C] = ndgrid(1:sz(1), 1:sz(2));
    new = ~containsTable(obj.DataKeyTable, R, C);
    
    % Add data keys for new input settings
    obj.DataKeyTable = addTableDatakeys(obj.DataKeyTable, R(new), C(new));
    
    % Get the datakeys for all cells required
    datakeys = getDatakeyFromTable(obj.DataKeyTable, R, C);
else
    datakeys = [];
end

function [obj, datakeys] = i_getcurrent(obj)
datakeys = getAllDatakeys(obj.DataKeyTable);
datakeys = datakeys(isPointSaved(obj.DataKeyTable));




%-------------------------------------------------------------------------|
function [chosenNode, ok] = i_ChooseOptimization(obj, axesVariables)
%-------------------------------------------------------------------------|
% if the user clicks cancel, ok is returned as false
chosenNode = [];
ok = false;

% get the optimization nodes from the cage browser
proj = project(obj);
optimNodes = filterbytype(proj, cgtypes.cgoptimtype);
nOptimNodes = length( optimNodes );

% Get the optim objects/ptrs from the optimNodes
optimPtr = null(xregpointer, size(optimNodes));
for i = 1:nOptimNodes,
    optimPtr(i) = getdata(optimNodes{i});
end

% What are appropriate optimization objects? 
%
% The list of all optimization objects in the project is filtered. To be 
% eligible for selection:
% 1) The object must be fully linked, that is, the optimization must be
%    ready to run (toolbar button enabled). The exception to this is when
%    the primary  operating point set has not been linked yet
% 2) The variables in the axes of the tradeoff tables must not be free 
%    variables in the optimization, e.g., if one of the axes is speed, then 
%    speed cannot be a free variable.
% 3) If the primary operating point set specifies the variables that must 
%    appear in it, then the axes variables must be a subset of the
%    operating point variables.
allowedOptims = true(nOptimNodes, 1);
for i = 1:nOptimNodes, 
    hOptim = optimPtr(i).info;
    % Check that the object is fully linked
    canRun = i_checkrun(hOptim);
    if ~canRun,
        allowedOptims(i) = false;
        continue
    end

    % Check free variables
    valuePtrs = get(hOptim, 'values' );
    if anymember(valuePtrs, axesVariables),
        allowedOptims(i) = false;
        continue
    end
    
    % check for specified variables in the primary operating point set
    oppointValues = get(hOptim, 'oppointValues' );
    if ~isempty(oppointValues) ...
            && ~isempty(oppointValues{1}) ...
            && ~all( ismember(axesVariables, oppointValues{1}) ),
        allowedOptims(i) = false;
        continue
    end
end

% Remove the optimizations that can't be used
optimNodes = optimNodes(allowedOptims);
nOptimNodes = length( optimNodes );

if nOptimNodes == 0,
    % There are no optimizations availiable
    xregerror( 'Automated Tradeoff Error', ['There are no optimizations '...
            'in this session that are compatible with this Tradeoff. Please '...
            'go to optimization to create one.'] );
    return
end

pOptimNodes = null(xregpointer, size(optimNodes));
for n = 1:numel(optimNodes)
    pOptimNodes(n) = address(optimNodes{n});
end

% Ask the user which optimization they want to use
figh = xregdialog('Name', 'Automated Tradeoff');
xregcenterfigure(figh, [350 200]);

txt = uicontrol('Parent', figh, ...
    'Style', 'text', ...
    'HorizontalAlignment', 'left', ...
    'String', 'Select an optimization to run:');
hList = cgoptimgui.optimList('Parent', figh, ...
    'Items', pOptimNodes, ...
    'SelectedItem', pOptimNodes(1));
hOK = uicontrol('Parent', figh, ...
    'Style', 'pushbutton', ...
    'String', 'OK', ...
    'callback', 'set(gcbf, ''tag'', ''ok'', ''visible'', ''off'');');
hCancel = uicontrol('Parent', figh, ...
    'Style', 'pushbutton', ...
    'String', 'Cancel', ...
    'callback', 'set(gcbf, ''tag'', ''cancel'', ''visible'', ''off'');');

lyt = xreggridbaglayout(figh, ...
    'packstatus', 'off', ...
    'dimension', [4 3], ...
    'rowsizes', [17 -1 7 25], ...
    'colsizes', [-1 65 65], ...
    'gapx', 7, ...
    'border', [7 7 7 10], ...
    'mergeblock', {[1 1], [1 3]}, ...
    'mergeblock', {[2 2], [1 3]}, ...
    'elements', {txt, hList, [],[],[],[],[],hOK, [],[],[],hCancel});
figh.LayoutManager = lyt;
set(lyt, 'packstatus', 'on');

figh.showDialog(hOK);

tg = get(figh, 'tag');
if strcmp(tg, 'ok')
    ok = true;
    chosenNode = info(hList.SelectedItem);
end
delete(figh);
drawnow('expose');



%-------------------------------------------------------------------------|
function [outputPtrs, values, OK] = i_SetUpandRunOptim(optimnode, pAxes)
%-------------------------------------------------------------------------|

% Get the optimization object
optim = getdata(optimnode); 

% if there is no primary data set, then create one
oppointLabels = optim.get('oppointLabels');
if length(oppointLabels) == 0,
    optim.info = optim.addOppoint;    
    ADDEDOPPT = true;
else
    ADDEDOPPT = false;
end

% Make a data set from the points to be run
oppoints = optim.get('oppoints');
if ~ADDEDOPPT && isvalid(oppoints(1))
    reqptrs = get(oppoints(1).info, 'ptrlist');
    mydata = get(oppoints(1).info, 'data');
    dataIdx = findptrs(pAxes, reqptrs);
    vals = pveceval(pAxes, @getvalue);
    if length(vals{1}) == size(mydata, 1)
        newdata = mydata;
    else
        newdata = repmat(mydata(1, :), length(vals{1}), 1);
    end
    for n = 1:length(vals)
        newdata(:, dataIdx(n)) = vals{n};
    end
else
    reqptrs = pAxes;
    vals = pveceval(pAxes, @getvalue);
    newdata = [vals{:}];
end
opp = cgoppoint(reqptrs, newdata); 

% Link the new data set to the optim
oppoints = optim.get('oppoints');
orig_oppointone = oppoints(1);
oppoints(1) = xregpointer(opp);
optim.info = optim.set('oppoints', oppoints);

% If this optimization is a sum optimization, need to link the new 
% operating point set to all the objective functions
objs = optim.get('objectivefuncs');
old_weights = cell(1, length(objs));
if objs(1).issum
    % Assumptions:
    % 1. 1 obj sum =>'s all obj sums
    % 2. All objective sums must be summed over the primary dataset
    Nthis = get(oppoints(1).info, 'numpoints');
    for i = 1:length(objs)
        old_weights{i} = get(objs(i).info, 'weights');
        objs(i).info = objs(i).set('oppoint', oppoints(1), 'weights', ones(Nthis, 1));
    end
end

% Must also link the operating point into the model constraints 
csums = optim.get('sumconstraints');
old_con_weights = cell(1, length(csums));
for i = 1:length(csums)
    old_con_weights{i} = get(csums(i).info, 'weights');
    csums(i).info = csums(i).set('oppoint', oppoints(1), 'weights', ones(Nthis, 1));
end

% Run the optimization
funh = Callbacks(optimnode, 'gethandles', optim);
feval(funh.Run, [], [],optimnode);
OK = getOutputInfo(optim.info);

if OK
    % Extract the information for passing back to tradeoff
    optimPtrs = getsolutionitems(optim.info);
    IsInport = pveceval(optimPtrs, @isinport);
    IsInport = [IsInport{:}];
    outsize = getsolutionsize(optim.info);
    selsol = ceil(outsize(3)/2);
    optimData = getsolution(optim.info, selsol);

    outputPtrs = optimPtrs(IsInport);
    values = optimData(:,IsInport);
else
    outputPtrs = null(xregpointer,0);
    values = [];
end

% Reset the optimization
optimoriginfo.oppoints = oppoints;
optimoriginfo.orig_oppointone = orig_oppointone;
optimoriginfo.old_weights = old_weights;
optimoriginfo.old_con_weights = old_con_weights;
optimoriginfo.ADDEDOPPT = ADDEDOPPT;
i_resetb4return(optim, optimoriginfo);


%-------------------------------------------------------------------------|
function i_resetb4return(optim, optimoriginfo)
%-------------------------------------------------------------------------|

% Retrieve original optimization settings
oppoints = optimoriginfo.oppoints;
orig_oppointone = optimoriginfo.orig_oppointone;
old_weights = optimoriginfo.old_weights;
old_con_weights = optimoriginfo.old_con_weights;
ADDEDOPPT = optimoriginfo.ADDEDOPPT;

% oppoints(1) is a pointer to a data set created by auto trade off. Must
% free at the end of this routine
op2free = oppoints(1);

if ADDEDOPPT
    % Assume here that if an oppt set has been added, there is only one
    % oppt set in the optim
    dslab = optim.get('oppointlabels');
    optim.info = optim.deleteOppoint(dslab{1});
else
    % Set the primary data set pointer back
    oppoints(1) = orig_oppointone;
    optim.info = optim.set('oppoints', oppoints);    
end

% Set the dataset pointer back in any sum objectives
objs = optim.get('objectivefuncs');
if objs(1).issum
    % Assumptions:
    % 1. 1 obj sum =>'s all obj sums
    % 2. All objective sums must be summed over the primary dataset
    for i = 1:length(objs)
        objs(i).info= objs(i).set('oppoint', orig_oppointone, 'weights', old_weights{i});
    end
end

% Set the dataset pointer back in any sum constraints
csums = optim.get('sumconstraints');
for i = 1:length(csums)
    csums(i).info = csums(i).set('oppoint', orig_oppointone,'weights', old_con_weights{i});
end

freeptr(op2free);


%-------------------------------------------------------------------------|
function [OK, msg] = i_checkrun( cgo )
%-------------------------------------------------------------------------|
% Modified version of @cgoptim/checkrun with some the reasons to not run removed
% also on the 'gui' case is done

% Checks to see if the run method can be called on cgoptim, that is all
% oppoint,  values, objective, constraint fields are filled and valid
%
% Checks on the oppoint have been removed.

OK = []; msg = [];

% check values
nvalues = length(get(cgo,'valueLabels'));
% do we have the correct number
cgo_values = get(cgo,'values');
if isempty(cgo_values)
    OK = 0;
    msg = 'The free variables have not been assigned';
end
if ~isequal(length(cgo_values), nvalues)
    OK = 0;
    msg = 'An incorrect number of free variables have been assigned';
    return
end
% are all pointers valid
for i = 1:nvalues
    OK = isvalid(cgo_values(i));
    if ~OK
        msg = 'Invalid free variable pointer';
        return
    end
end

%check objectives
cgo_objectiveFuncLabels = get( cgo, 'objectiveFuncLabels' );
cgo_objectiveFuncs = get( cgo, 'objectiveFuncs' );
nobjectives = length(cgo_objectiveFuncLabels);
% do we have the correct number
if ~isequal(length(cgo_objectiveFuncs), nobjectives)
    OK = 0;
    msg = 'An incorrect number of objectives have been assigned';
    return
end
% are all pointers valid
for i = 1:nobjectives
    if nobjectives == 1 && isempty(cgo_objectiveFuncLabels{1})
        % No obs in this opt - don't check
        break;
    end    
    pThisObj = cgo_objectiveFuncs(i);
    OK = isvalid(pThisObj);
    if ~OK
        msg = 'Invalid objective pointer';
        return
    end
    % Addn ... and is there a modptr in the obj func
    if isempty(get(pThisObj.info, 'modptr'))
        OK = 0;
        msg = 'At least one of the objectives does not have an associated model';
        return;
    end
end

%check constraints
cgo_constraintLabels =get( cgo, 'constraintLabels' );
cgo_constraints =get( cgo, 'constraints' );
ncon = length(cgo_constraintLabels);
% do we have the correct number
if ~isequal(length(cgo_constraints), ncon)
    OK = 0;
    msg = 'An incorrect number of constraints have been assigned';
    return
end
% are all pointers valid
for i = 1:ncon
    if ncon == 1 && isempty(cgo_constraintLabels{1})
        % No constraints in this opt - don't check
        break;
    end        
    OK = isvalid(cgo_constraints(i));
    if ~OK
        msg = 'Invalid constraint pointer';
        return
    end
    % do all of the constraint models have model pointers
    pCon = cgo_constraints(i);
    flag = pCon.ismodel;
    if flag && isempty(get(pCon.info, 'modptr'))
        OK = 0;
        msg = 'Not all constraints have an associated model';
        return;
    end
end

