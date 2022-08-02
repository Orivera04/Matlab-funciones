function pSetupConLayout(d)
%PSETUPCONLAYOUT Private method to set up the constraints layout
%
%  PSETUPCONLAYOUT(VIEWDATA)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:27:52 $ 

crd = get(d.Handles.GraphCard, 'currentcard');
if crd == 1
    ON = 'on';
else
    ON = 'off';
end
if d.ConListShowing && d.ConGraphsShowing
    set(d.Handles.ConstraintLayout, 'dimension', [3 1], ...
        'rowratios', [2 2 1], ...
        'elements', {d.Handles.ObjPanel, d.Handles.ConPanel, d.Handles.ConListPanel});
    set(d.Handles.ConPanel, 'visible', ON);
    set(d.Handles.ConListPanel, 'visible', ON);
elseif d.ConGraphsShowing
    set(d.Handles.ConstraintLayout, 'dimension', [2 1], ...
        'rowratios', [1 1], ...
        'elements', {d.Handles.ObjPanel, d.Handles.ConPanel});
    set(d.Handles.ConPanel, 'visible', ON);
    set(d.Handles.ConListPanel, 'visible', 'off');
elseif d.ConListShowing
    set(d.Handles.ConstraintLayout, 'dimension', [2 1], ...
        'rowratios', [3 1], ...
        'elements', {d.Handles.ObjPanel, d.Handles.ConListPanel});
    set(d.Handles.ConPanel, 'visible', 'off');
    set(d.Handles.ConListPanel, 'visible', ON);
else
    set(d.Handles.ConstraintLayout, 'dimension', [1 1], ...
        'rowratios', 1, ...
        'elements', {d.Handles.ObjPanel});
    set(d.Handles.ConPanel, 'visible', 'off');
    set(d.Handles.ConListPanel, 'visible', 'off');
end