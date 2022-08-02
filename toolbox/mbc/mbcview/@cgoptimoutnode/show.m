function d=show(nd,cgh,d)
%SHOW  Browser interface show method
%
%  VIEW = SHOW(NODE, CGH, VIEW)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.10.6.1 $    $Date: 2004/02/09 08:27:55 $

pOptim = getdata(nd);

d.CurrentSolution = 1;
d.CurrentOpPoint = 1;

% Enable the appropriate views
pEnableViews(d, pOptim);

% If currentview is disabled, switch to view 1
if strcmp(get(d.Handles.Toolbar.View(d.CurrentView), 'enable'), 'off')
    set(d.Handles.Menu.View(d.CurrentView), 'checked', 'off');
    set(d.Handles.Toolbar.View(d.CurrentView), 'state', 'off');
    set(d.Handles.Menu.View(1), 'checked', 'on');
    set(d.Handles.Toolbar.View(1), 'state', 'on');
    set(d.Handles.GraphCard, 'currentcard', 1);
    d.CurrentView = 1;
end

% Re-init the index controls
pInitIndexControls(d, pOptim);

d.Handles.Table.initializeData(d.CurrentView, pOptim, d.CurrentSolution, d.CurrentOpPoint);
d.Handles.ObjectiveGraphs.initializeData(d.CurrentView, pOptim, d.CurrentSolution, d.CurrentOpPoint);
d.Handles.ParetoGraphs.initializeData(d.CurrentView, pOptim, d.CurrentSolution, d.CurrentOpPoint);

% Constraint updating is expensive, so we need to be careful here
if d.CurrentView==1 || d.CurrentView==4
    if d.ConListShowing
        d.Handles.ConstraintList.initializeData(pOptim, d.CurrentSolution, d.CurrentOpPoint);
    else
        d.Handles.ConstraintList.OptimizationObject = [];
    end
    if d.ConGraphsShowing
        d.Handles.ConstraintGraphs.initializeData(pOptim, d.CurrentSolution, d.CurrentOpPoint);
    else
        d.Handles.ConstraintGraphs.OptimizationObject = [];
    end
end