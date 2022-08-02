function d=view(nd,cgh,d)
%VIEW Browser interface view method
%
%  VIEW = VIEW(NODE, CGH, VIEW)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.8.6.1 $    $Date: 2004/02/09 08:27:57 $

pOptim = getdata(nd);

% Set up table
d.Handles.Table.setCurrentSolution(d.CurrentView, d.CurrentSolution, d.CurrentOpPoint);

% Set up graphs
d.Handles.ObjectiveGraphs.setCurrentSolution(d.CurrentView, d.CurrentSolution, d.CurrentOpPoint);
d.Handles.ParetoGraphs.setCurrentSolution(d.CurrentView, d.CurrentSolution, d.CurrentOpPoint);

% Set up algorithm stats
d.Handles.AlgStats.ListText = pAlgStats(d, nd);

% Set up free variable values
d.Handles.FreeVars.ListText = pFreeVarString(d, pOptim);

% Constraint updating is expensive, so we need to be careful here
if d.CurrentView==1 || d.CurrentView==4
    if d.ConListShowing
        d.Handles.ConstraintList.setSolutionData(d.CurrentSolution, d.CurrentOpPoint);
    end
    if d.ConGraphsShowing
        d.Handles.ConstraintGraphs.setSolutionData(d.CurrentSolution, d.CurrentOpPoint);
    end
end