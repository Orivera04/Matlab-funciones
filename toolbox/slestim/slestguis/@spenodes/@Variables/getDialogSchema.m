function DialogPanel = getDialogSchema(this, manager)
% GETDIALOGSCHEMA Construct the dialog panel for Variables nodes

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.5 $ $Date: 2004/04/11 00:40:28 $

% First create the GUI panel...
DialogPanel = com.mathworks.toolbox.slestim.variables.VariablesPanel;

% ... then initialize its data. Will fire listeners.
this.initialize;

% Configure panels
this.configureParameterPanel( DialogPanel.getParameterPanel, manager );
this.configureStatePanel( DialogPanel.getStatePanel, manager );
