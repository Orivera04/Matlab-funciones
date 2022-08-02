function DialogPanel = getDialogSchema(this, manager)
% GETDIALOGSCHEMA Construct the dialog panel for @SteadyStateDataLeaf nodes

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.5 $ $Date: 2004/04/11 00:39:35 $

% First create the GUI panel...
DialogPanel = com.mathworks.toolbox.slestim.data.SteadyStateDataLeaf;

% ... then initialize its data. Will fire listeners.
this.initialize;

% Configure panels
this.configureInputPanel( DialogPanel.getSteadyStateInData,  manager);
this.configureOutputPanel(DialogPanel.getSteadyStateOutData, manager);
this.configureStatePanel( DialogPanel.getSteadyStateICData,  manager);
