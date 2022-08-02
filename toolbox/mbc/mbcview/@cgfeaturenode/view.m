function View = view(nd, cgh, View)
%VIEW
%
%  VIEWDATA = VIEW(NDE, CGBH, VIEWDATA)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.7.2.4 $  $Date: 2004/02/09 08:24:14 $

% first setup the model description text, and enable menus etc
i_ModelDescription( nd, View );

% refresh the history listview
View = pHistoryManager( address(nd), View, 'drawlist' );

% and also clean out the optim managers
View = i_OptManagerRefresh( nd, View );


%------------------------------------------------------------
function i_ModelDescription(nd,d)
%------------------------------------------------------------
% This function constructs the models description string, and sets the
% ModText controls to show this.  Also enables/disables menus and other
% controls based on whether there is a moels or not.

pF = getdata(nd);
sf = pF.info;

eqPtr=get(sf , 'equation');
modPtr=get(sf , 'model');

% Determine model status
if isempty(modPtr) || ~isvalid(modPtr)
   modelMenuEnabled = 'off';
   mod = 'No model selected'; 
else
   modelMenuEnabled = 'on';
   inputNames = pveceval( modPtr.getdditems, 'getname' );
   % construct string "<modelname>,   Inputs: <in1>, <in2>,....<inN>"
   mod = sprintf('%s,   Inputs: %s%s', getname(modPtr.info), sprintf('%s, ', inputNames{1:end-1}), inputNames{end});
end

% push all this into the correct places
d.Handles.equationview.setexpr( eqPtr, name(nd) );
set([d.Handles.ModDeselect, d.Handles.DeselMenu] , 'enable' , modelMenuEnabled);
set(d.Handles.ModText , 'string' , mod);
set(d.Handles.ModEdit , 'enable' , 'on');

%------------------------------------------------------------
function d = i_OptManagerRefresh(nd, d)
%------------------------------------------------------------

pF = getdata(nd);

% kill the old optmgrs since the situation may have changed
d.InitialisationManager  = [];
d.FillManager  = [];
d.OptimisationManager  = [];

toolbarButtons = [d.Handles.Toolbar.Initialise,...
    d.Handles.Toolbar.Fill,...
    d.Handles.Toolbar.Optimise];
menuItems = [d.Handles.InitialiseMenu,...
    d.Handles.FillMenu,...
    d.Handles.OptimiseMenu];

% do not recreate the optmgrs here, just check for equations and models
if isempty(pF.get('equation')) || isempty(pF.get('model'))
   set(toolbarButtons, 'enable', 'off');
   set(menuItems, 'enable', 'off');
else
   set(toolbarButtons, 'enable', 'on');
   set(menuItems, 'enable', 'on');
end
