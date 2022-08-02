function pForceRefresh(d)
%PFORCEREFRESH Force refresh of browser display
%
%  PFORCEREFRESH(VIEWDATA)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.8.2 $    $Date: 2004/02/09 08:27:49 $ 

% Force an update of the table display
d.Handles.Table.update;
d.Handles.ObjectiveGraphs.update;
d.Handles.ParetoGraphs.update;

% Constraint updating is expensive, so we need to be careful here
if d.CurrentView==1 || d.CurrentView==4
    % Update value in edit box
    d.Handles.Index.Value = d.CurrentSolution;
    if d.ConListShowing
        d.Handles.ConstraintList.update;
    end
    if d.ConGraphsShowing
        d.Handles.ConstraintGraphs.update;
    end
else
    % Update value in edit box
    d.Handles.Index.Value = d.CurrentOpPoint;
end
