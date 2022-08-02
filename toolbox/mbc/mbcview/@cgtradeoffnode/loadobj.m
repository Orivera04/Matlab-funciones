function obj = loadobj(obj)
%LOADOBJ Load-time actions for cgtradeoffnode
%
%  OBJ = LOADOBJ(OBJ) is called when an object is loaded from a mat file.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.3 $    $Date: 2004/04/04 03:36:34 $ 

if isstruct(obj) && ~isfield(obj, 'Version');
        % Version 1 -> 2 upgrade
        old_parent = obj.cgcontainer;
        new_parent = tocgnode(old_parent);
        empty_ptr = null(xregpointer, 0);
        obj = struct('Tables', empty_ptr, ...
            'FillExpressions', empty_ptr, ...
            'FillMaskExpressions', empty_ptr, ...
            'ObjectKey', guidarray(1), ...
            'DataKeyTable', cgtradeoffkeytable, ...
            'GraphExpressions', empty_ptr, ...
            'GraphDisplayError', false, ...
            'GraphDisplayConstraints', false, ...
            'GraphDisplaySameY', true, ...
            'GraphHideExpressions', empty_ptr, ...
            'Version', 2, ...
            'cgnode', new_parent);
        
        pOldTradeoff = getdata(old_parent);
        loadactions = mbcloadrecorder('current');
        
        % Schedule a rename correction once heap is loaded.
        loadactions.add({@i_renameitem, address(new_parent), pOldTradeoff}, ...
            '16-Sep-2003');
        
        % Schedule a complete construction of data from old tradeoff once
        % heap is loaded.
        loadactions.add({@i_constructfromoldtradeoff, address(new_parent), pOldTradeoff}, ...
            '17-Sep-2003');
end

if isstruct(obj)
    % Ask constructor to convert to object
    obj = cgtradeoffnode(obj);
end





function i_renameitem(pPROJ, evt, pTO, pOldTradeoff)
pTO.name(pOldTradeoff.getname);


function i_constructfromoldtradeoff(pPROJ, evt, pTO, pOldTradeoff)
obj = pTO.info;
old_obj = pOldTradeoff.info;

% ------  Transfer straightforward settings  ------
obj.Tables = get(old_obj, 'tableptrs');
obj.GraphExpressions = get(old_obj, 'viewstore');
obj.GraphDisplayError = get(old_obj, 'errordisp');
obj.GraphDisplaySameY = get(old_obj, 'sameylimits');
obj.GraphHideExpressions = [get(old_obj, 'hiddenfactors'), get(old_obj, 'hiddenmodels')];

% ------  Transfer fill expression setup  ------
obj = i_recreateFillExpressions(obj, old_obj, pPROJ);

% ------  Transfer saved tradeoff points  ------
obj = i_transferSavedPoints(obj, old_obj);

% ------  Transfer extrapolation mask and regions into tables and  ------
% ------  fix the locks and size lock in each one.
passign(obj.Tables, pveceval(obj.Tables, @i_fixtables, obj, old_obj));


% Update heap copy of object
xregpointer(obj);

% Free the old tradeoff
freeptr(pOldTradeoff);

% Free the old oppoint - this _may_ be linked in as a project node, in this
% case we can delete it so long as noone else is using the dataset.
pPoints = get(old_obj, 'oppoint');
nds = pPROJ.preorder(@findptr, pPoints);
nds = [nds{:}];
if length(nds)==1 && all(pPoints==getprimaryitems(nds.info))
    % Remove the datasetnode from the project
    pPROJ.setdeleting(true);
    nds.delete;
    freeptr(pPoints);
    pPROJ.setdeleting(false);
elseif isempty(nds)
    freeptr(pPoints);
end



% -------------------
% Create the correct fill and mask expressions for the tradeoff
% -------------------
function obj = i_recreateFillExpressions(obj, old_obj, pPROJ)
fillExpr = get(old_obj, 'fillptrs');
obj.FillExpressions = null(xregpointer, 1, length(obj.Tables));
obj.FillMaskExpressions = obj.FillExpressions;
if isempty(fillExpr)
    anyOldMM = false(0);
else
    anyOldMM = any(cellfun('isclass', fillExpr, 'cell'));
end
TRY_MM_LOAD = true;
pModelsToRem = null(xregpointer,0);
if anyOldMM
    % Need the inputs corresponding to the breakpoints for creating a new
    % switch model
    pT = obj.Tables(1);
    pNorms = pT.getinputs;
    if length(pNorms)~=2 || any(isnull(pNorms))
        warning('mbc:cgtradeoffnode:InvalidState', ...
            ['Unable to update multimodel tradeoff because the first ' ...
            'table does not have a single X input and a single Y input.'], ...
            name(obj));
        TRY_MM_LOAD = false;
    else
        pT.setinportsforcells;
        pYVar = pNorms(1).getsource;
        pXVar = pNorms(2).getsource;
    end
end
for n = 1:length(fillExpr)
    if isa(fillExpr{n}, 'xregpointer')
        obj.FillExpressions(n) = fillExpr{n};
        obj.FillMaskExpressions(n) = fillExpr{n};
    elseif iscell(fillExpr{n})
        % Multimodel cell array of pointers
        allptrs = [fillExpr{n}{:}];
        if all(allptrs==allptrs(1))
            % All pointers are the same: assume they are a variable
            obj.FillExpressions(n) = allptrs(1);
            obj.FillMaskExpressions(n) = allptrs(1);
        else
            % Need to construct a switch model from these pointers
            if TRY_MM_LOAD
                obj.FillExpressions(n) = i_makeswitchmodel(fillExpr{n}, pYVar, pXVar);
                obj.FillMaskExpressions(n) = obj.FillExpressions(n);

                % Add the new model to the project as a new model node
                pPROJ.addtoproject(obj.FillExpressions(n));

                % Check that hidden models array does not need to be
                % altered to include this model instead of any of the
                % original models.
                RemFromHidden = ismember(obj.GraphHideExpressions, [fillExpr{n}{:}]);
                if any(RemFromHidden)
                    obj.GraphHideExpressions(RemFromHidden) = [];
                    obj.GraphHideExpressions = [obj.GraphHideExpressions, obj.FillExpressions(n)];
                end
                
                % Add old model pointers to list of those to remove
                pModelsToRem = [pModelsToRem, fillExpr{n}{:}];
            end
        end
    end
end

% Decide which, if any, Fill Expression to use as a fill mask
validfill = obj.FillExpressions(~isnull(obj.FillExpressions));
isSwitch = pveceval(validfill, @isSwitchExpr);
isSwitch = [isSwitch{:}];
if any(isSwitch)
    switchptrs = validfill(isSwitch);
    obj.FillMaskExpressions(~isnull(obj.FillExpressions)) = switchptrs(1);
end

% Delete old models if required
if ~isempty(pModelsToRem)
    hResults = xregGui.RunTimePointer(struct( ...
        'NumUserNodes', zeros(size(pModelsToRem)), ...
        'LastNode', null(xregpointer, size(pModelsToRem))));
    % Recurse down project looking for pointers
    pPROJ.preorder(@i_findnodes, pModelsToRem, hResults);
    data = hResults.info;
    
    % Free model pointers that don't even have a node for some reason
    freeptr(pModelsToRem(data.NumUserNodes==0));
    
    % Check that models with a single user have found the correct model
    % node and delete them
    nodesidx = find(data.NumUserNodes==1);
    pPROJ.setdeleting(true);
    for n = nodesidx
        if all(pModelsToRem(n)==getprimaryitems(data.LastNode(n).info))
            delete(data.LastNode(n).info);
        end
    end
    freeptr(pModelsToRem(nodesidx));
    pPROJ.setdeleting(false);  
end


% -------------------
% Copy across the saved points from an old tradeoff
% -------------------
function obj = i_transferSavedPoints(obj, old_obj)
pPoints = get(old_obj, 'oppoint');
pVars = pPoints.get('ptrlist');
if isempty(pVars)
    % Guard against a non-pointer return from this method
    pVars = null(xregpointer, 0);
end
Data = pPoints.get('data');
nPoints = size(Data, 1);
nVars = length(pVars);

% Set up data key mapping.  This involves finding which row and column each
% saved point is at.
if length(obj.Tables)>0
    obj.DataKeyTable = setNewTableSize(obj.DataKeyTable, obj.Tables(1).getTableSize);
end
[obj.DataKeyTable, datakeys] = addDatakeys(obj.DataKeyTable, nPoints);
obj.DataKeyTable = incrementSaveCounter(obj.DataKeyTable, datakeys);


% Create a store for each variable.
s = mbcstore;
hVars = infoarray(pVars);
for n = 1:nVars
    s = setvalue(s, datakeys, Data(:, n));
    hVars{n} = addstore(hVars{n}, obj.ObjectKey, s);
    s = clear(s);
end
passign(pVars, hVars);

% Create row/column mappings for each saved point
if length(obj.Tables)>0
    pT = obj.Tables(1);
    pNorms = pT.getinputs;
    pYVar = pNorms(1).getsource;
    pXVar = pNorms(2).getsource;
    if length(pYVar)~=1 || length(pXVar)~=1
        warning('mbc:cgtradeoffnode:InvalidState', ...
            ['Unable to recreate the row/column linking for the ' ...
            'saved points in  tradeoff "%s" because there is not a single ' ...
            'X input and a single Y input.'], name(obj));
    else
        Ridx = (pYVar==pVars);
        Cidx = (pXVar==pVars);
        if isempty(Ridx) || isempty(Cidx)
            warning('mbc:cgtradeoffnode:InvalidState', ...
                ['Unable to recreate the row/column linking for the ' ...
                'saved points in  tradeoff "%s" because the X and Y input ' ...
                'variables could not be found in the old list of saved points.'], ...
                name(obj));
        else
            pYVar.info = pYVar.setvalue(Data(:, Ridx));
            pXVar.info = pXVar.setvalue(Data(:, Cidx));
            Rows = fix(pNorms(1).i_eval) + 1;
            Cols = fix(pNorms(2).i_eval) + 1;
            obj.DataKeyTable = linkDatakeyToTable(obj.DataKeyTable, datakeys, Rows, Cols);
        end
    end
end




% -------------------
% Check whether node knows about any of the model pointers
% -------------------
function out = i_findnodes(nd, pModels, hResults)
nodeptrs = getptrs(nd);
matched = ismember(pModels, nodeptrs);
data = hResults.info;
data.NumUserNodes(matched) = data.NumUserNodes(matched) + 1;
data.LastNode(matched) = address(nd);
hResults.info = data;
out = [];



% -------------------
% Copy tradeoff masks into table and fix up locks
% -------------------
function tbl = i_fixtables(tbl, Newtradeoff, Oldtradeoff)
% Old tradeoff object has been given the necessary table interfaces for
% this to work.
tbl = copyExtrapolationMaskFrom(tbl, Oldtradeoff);
tbl = copyExtrapolationRegionsFrom(tbl, Oldtradeoff);

% Add a size lock for the new tradeoff
tbl = addsizelock(tbl, Newtradeoff.ObjectKey);

% If all cells in table are locked, this is probably because the old
% tradeoff thought it was a good idea!  They can thus be unlocked.
locks = get(tbl, 'vlocks');
if all(locks(:));
    tbl = set(tbl, 'vlocks', zeros(getTableSize(tbl)));
end


% -------------------
% Create a switch model from a cell array of other models
% -------------------
function pSwitchExpr = i_makeswitchmodel(modelcell, pRowVar, pColVar)

% Find where each old model is
idx = find(~cellfun('isempty', modelcell));
[R, C] = ind2sub(size(modelcell), idx);

% Create basic switch model
RowVals = pRowVar.getvalue;
ColVals = pColVar.getvalue;
xinfo = struct('Names', {{''; ''}}, ...
    'Units', {{junit; junit}}, ...
    'Symbols', {{pRowVar.getname; pColVar.getname}});

% Extract core models and information out of the layers and create a new
% switching model
pModExpr = [modelcell{idx}];
hMods = pveceval(pModExpr, @get, 'model');
name = i_createname(pModExpr(1).getname, pModExpr(2).getname);
info = getinfo(hMods{1});
for n = 1:length(hMods)
    hMods{n} = model(hMods{n});
end
m = xregmodswitch(hMods, [RowVals(R), ColVals(C)], xinfo);

% Wrap as an export model
sm = xregstatsmodel(m, name, info, []);

% Wrap in a cage model expression and link up to the correct inputs
hSwitchExpr = cgmodexpr(name, sm);
pInp = [pModExpr(1).getinputs, pRowVar, pColVar];
hSwitchExpr =  set(hSwitchExpr , 'ptrlist' , pInp);

pSwitchExpr = xregpointer(hSwitchExpr);


% -------------------
% Create a correct switch model name from two name samples
% -------------------
function name = i_createname(name1, name2)

NCompareChars = min(length(name1), length(name2));
ischarmatch = name1(1:NCompareChars)==name2(1:NCompareChars);
non_match = find(~ischarmatch);
if isempty(non_match)
    name = name1;
else
    name = name1(1:non_match(1)-1);
    if strcmp(name(end), '_')
        % Strip of a trailing underscore
        name = name(1:end-1);
    end
end
