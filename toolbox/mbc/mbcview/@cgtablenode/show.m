function d = show(node, cgb, d)
%SHOW Configure the browser display for tables
%
%  DATA = SHOW(NODE, CGB, DATA) configures the browser's table node view.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.2.4 $  $Date: 2004/04/04 03:34:23 $

ParentNode = Parent(node);
pT = getdata(node);
NumAx = pT.getNumAxes;
IsTableEmpty = pT.isempty;

% Decide whether we are being viewed as part of a feature or not
if isa(ParentNode.info, 'cgfeaturenode')
    d.FeaturePointer = ParentNode.getdata;
else
    d.FeaturePointer = xregpointer;
end

if pT.getNumAxes==1
    d.Handles.Editor1D.settable(pT);
else
    d.Handles.Editor2D.settable(pT);
end
d.Handles.FeatureComp.plotcomparison(d.FeaturePointer, pT);
d.SuppressViewUpdate = true;

% Set the editor for the table dimensions
set(d.Handles.TopCard, 'CurrentCard', NumAx);

% Set the comparison pane split appropriately
if isempty(d.FeaturePointer) || isnull(d.FeaturePointer)
    set(d.Handles.Split, 'state', 'bottom', ...
        'splitenable', 'off');
else
    set(d.Handles.Split, 'splitenable', 'on');
    if d.ComparisonPaneRequested
        % Ensure that the split is open
        set(d.Handles.Split, 'state', 'center');
    end
end

% Set a message if the table needs to be initialised
if IsTableEmpty
    if ~isempty(d.ShownMessageID)
        cgb.removeStatusMsg(d.ShownMessageID);
    end
    d.ShownMessageID = cgb.addStatusMsg(['This table needs to be set up in the' ...
        ' Calibration Manager before any further analysis can be done']);
end

% Enable the appropriate menu items and toolbar buttons
menuEn = repmat({'off'}, 24,1);
tbEn = repmat({'off'}, 5,1);

% Always show history menu and properties menu
menuEn = i_setcellvalues(menuEn, [1 16], 'on');

% Always show context menu items
menuEn = i_setcellvalues(menuEn, 17:24, 'on');

if ~isnull(d.FeaturePointer)
    % Enable comparison pane switching
    menuEn{2} = 'on';
end
if ~IsTableEmpty
    % Enable standard table ops
    menuEn = i_setcellvalues(menuEn, [5 8 9 10 13 14 15], 'on');
    tbEn = i_setcellvalues(tbEn, [1 4 5], 'on');
end
if ~isnull(d.FeaturePointer) && ~IsTableEmpty
    % Enable feature-based table ops
    menuEn = i_setcellvalues(menuEn, [6 7 11 12], 'on');
    tbEn = i_setcellvalues(tbEn, [2 3], 'on');
end

if NumAx==2
    % Enable rotate/edit options in View menu
    menuEn = i_setcellvalues(menuEn, [3 4], 'on');
end

vm = d.Handles.ViewMenu;
tm = d.Handles.TableMenu;
cm = d.Handles.TableContext;
set([vm.History; ...
    vm.CompPane; ...
    vm.RotateSurf; ...
    vm.EditSurf; ...
    tm.Init; ...
    tm.Fill; ...
    tm.Optimize; ...
    tm.Invert; ...
    tm.MathEdit; ...
    tm.ExtrapMask; ...
    tm.PEMask; ...
    tm.BoundaryMask; ...
    tm.Extrapolate; ...
    tm.Locks; ...
    tm.ConvToModel; ...
    tm.Props; ...
    cm.MaskAddSel; ...
    cm.MaskRemoveSel; ...
    cm.MaskClear; ...
    cm.LocksAddSel; ...
    cm.LocksRemoveSel; ...
    cm.LocksAddAll; ...
    cm.LocksClear; ...
    cm.MathEdit; ...
    ], ...
    {'enable'}, menuEn);

tb = d.Handles.Toolbar;
set([tb.Init; ...
    tb.Fill; ...
    tb.Optimize; ...
    tb.Invert; ...
    tb.Extrapolate], ...
    {'enable'}, tbEn);



function c = i_setcellvalues(c, ind, val)
for n = ind(:)'
    c{n} = val;
end
