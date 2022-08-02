function ud = view(node,cgb,ud)
%VIEW Browser GUI pane interface function
%
%  DATA = VIEW(NODE, HBROWSER, DATA)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.4 $  $Date: 2004/04/04 03:33:37 $

Tnode = Parent(node);
if Tnode==address(project(node))
    featurenode = [];
    tablenode = address(node);
else
    featurenode = bpeditorinputs(Tnode.info);
    tablenode = Tnode;
end


% set up view data with node-specific data
[Data,SFData] = getBPEditorData(tablenode.info);
ud.FeatureData = SFData;


tableptr = tablenode.getdata;
ud.TablePtr = tableptr;

% Kill off any optim managers that might be floating about.
tablenode.info = killbpom(tablenode.info);

if isnormempty(tableptr.info)
    % uninitialised table
    i_SetMenuAndToolbarStates(ud,'off','off','off');
    set(ud.Handles.Display,'splitenable','off','state','bottom'); % can't compare this to anything
    ud.NormCount = 0;
    i_configure(ud);
    pMessage(ud, 'This table needs to be set up in the Calibration Manager before any further analysis can be done.');
else
    i_SetMenuAndToolbarStates(ud,'on','on','on');
    ud.FeatureData = [];%tablenode.get('SFData');
    if isempty(ud.FeatureData)
        % no current data to use in the comparison pane.
        ud = i_GetFeatureData(ud,featurenode);
    end
    if ~isempty(ud.FeatureData) && ~isempty(ud.FeatureData.Model)
        set(ud.Handles.Display,'splitenable','on'); % allow comparison
        ud = i_SetComparisonVariables(ud);
    else
        set(ud.Handles.Display,'splitenable','off','state','bottom'); % disallow comparison
    end
    ud = i_PlotBreakpoints(ud);
    cgb.setViewData(ud);
end

% save node-specific data here
SFData = ud.FeatureData;
tablenode.info = setBPEditorData(tablenode.info,Data,SFData);


% -------------------------------------------------------
function i_configure(ud)
% -------------------------------------------------------

switch ud.NormCount
case 2
    % must be a two-normaliser display
    set(ud.Handles.TableSplit,'currentcard',3);
    set(ud.Handles.Menus.history,'enable','on');
case 1
    % single normaliser
    set(ud.Handles.TableSplit,'currentcard',2);
    set(ud.Handles.Menus.history,'enable','on');
case 0
    % blank pane
    set(ud.Handles.TableSplit,'currentcard',1);
    set(ud.Handles.Menus.history,'enable','off');
end

if isempty(ud.FeatureData) || isempty(ud.FeatureData.Model)
    % no model.  disable "Initialise" and "Optimise"
    i_SetMenuAndToolbarStates(ud,[],'off','off');
else
    i_SetMenuAndToolbarStates(ud,[],'on','on');
end

pSetComparisonMenu(ud);

%--------------------------------------------
function ud = i_CalculateModelData(ud)
%--------------------------------------------

if isempty(ud.FeatureData) || isempty(ud.FeatureData.Model)
    return;
end

vec = ud.FeatureData.Model.vectors;
if length(vec) > 2
    pMessage(ud, 'Too many vector valued variables to give a display.');
    ud.FeatureData = [];
    return
end

[OK,msg] = settingscheck(ud.TablePtr.info);
if ~OK % Some duff intialisation going on, tell them to do something about it 
    pMessage(ud, msg);
    return
end

[X,Y,M] = return_data(ud.TablePtr.info,ud.FeatureData.Model); % Let the object methods sort out what we might want to see.
% we will merely concern ourselves with the results.
% Strip out complex behaviour - set complex values to 0.
Ind = find((M').'-M);
M(Ind) = 0;

ud.FeatureData.XData = X; % X Coordinates of surface
ud.FeatureData.YData = Y; % Y Coordinates of surface (empty if we are to plot a line);
ud.FeatureData.MData = M; % Z Coordinates of Model response surface

return

% -------------------------------------------
function ud = i_PlotBreakpoints(ud)
% -------------------------------------------

ud = i_CalculateModelData(ud);

% comparison pane first
if strcmp(get(ud.Handles.Display,'state'),'center')
    ud = pPlotComparison(ud);
end

fdata = ud.FeatureData;
T = ud.TablePtr;
if ~isempty(fdata)
    if isempty(fdata.Model)
        fdata = [];
    else
        fdata.VarPtrs = T.getinports;
    end
end

% now the breakpointeditors
pane = ud.Handles.TablePane(1);
ud.NormCount = 1;
if T.isa('cglookupone') || T.isa('cgnormaliser')
    % cglookupone or cgnormaliser
    pane.showbreakpoints(T,fdata);
    ud.Handles.TableList = T;
elseif T.isa('cgnormfunction')
    x = T.get('x');
    pane.showbreakpoints(x,fdata);
    ud.Handles.TableList = x;
elseif T.isa('cglookuptwo')
    x = T.get('x');
    y = T.get('y');
    
    if (~isempty(fdata) && length(fdata.VarPtrs)==2)
        v = x.getinports;
        % getinports may return more than one pointer.  In this case
        % the next if statement isn't correct.
        % reverse the inputs if necessary.  The x-input must be first
        if v~=fdata.VarPtrs(1)
            fdata.VarPtrs = fdata.VarPtrs([2,1]);
        end
    end
    
    pane.showbreakpoints(x,fdata);
    pane2 = ud.Handles.TablePane(2);
    pane2.showbreakpoints(y,fdata);
    ud.Handles.TableList = [x y];
    ud.NormCount = 2;
else
    error('mbc:cgnormnode:view:UnknownTableClass', 'Unknown table type "%s"', T.class);
end
i_configure(ud);


%--------------------------------------------
function ud = i_SetComparisonVariables(ud)
%--------------------------------------------

if isempty(ud.FeatureData) || isempty(ud.FeatureData.Model)
    return
end

% First vector inputs
tableinputs = ud.TablePtr.getinports;
ud.Store.VarPtrs = tableinputs;
for i = 1:length(tableinputs)
    % Set each table input to be 20 points over its range.  Store the
    % previous value so we can reset it later.
    ud.Store.VarVals{i} = tableinputs(i).eval;
    range = tableinputs(i).get('range');
    val = linspace(range(1),range(2),20).';
    tableinputs(i).info = tableinputs(i).set('value',val);
end

% Now scalar inputs
consts = ud.FeatureData.ConstInputs;
ud.Store.ConstPtrs = consts;
for i = 1:length(consts)
    % Set each constant input to the nominal value.  Store the previous
    % value so that we can reset it later.
    ud.Store.ConstVals{i} = consts(i).eval;
    val = consts(i).get('setpoint');
    consts(i).info = consts(i).set('value',val);
end

return

%--------------------------------------------
function ud = i_GetFeatureData(ud,featurenodeptr)
%--------------------------------------------

if isempty(featurenodeptr)
    % No feature. Hide the Comparison pane, and disable "Fill" and "Optimise" options.
    ud.FeatureData = [];
    return;
else
    fp = featurenodeptr.getdata; % feature pointer
    mp = fp.get('model'); % model pointer
    ud.FeatureData.Model = mp;
    ud.FeatureData.Feature = fp;
    if isempty(ud.FeatureData.Model)
        return;
    end
end

[OK,msg] = cgchecktableinputs(ud.TablePtr, ud.FeatureData.Feature);
if ~OK
    pMessage(ud,  sprintf('Can''t plot comparison: %s', msg) );
    ud.FeatureData.Model = []; % can't compare with model
    return;
end

ud.FeatureData.ConstInputs = cgidentifyconsts(ud.TablePtr, ud.FeatureData.Feature);


% -------------------------------------------
function i_SetMenuAndToolbarStates(ud,autospace,initialise,optimise)
% -------------------------------------------
tb = ud.ToolBar.Handles;
menus = ud.Handles.Menus;
if ~isempty(autospace)
    set(tb.Autospace,'enable',autospace); 
    set(menus.Autospace,'enable',autospace);
end
if ~isempty(initialise)
    set(tb.Initialise,'enable',initialise);
    set(menus.Initialise,'enable',initialise);
end
if ~isempty(optimise)
    set(tb.Optimise,'enable',optimise);
    set(menus.Optimise,'enable',optimise);
end


