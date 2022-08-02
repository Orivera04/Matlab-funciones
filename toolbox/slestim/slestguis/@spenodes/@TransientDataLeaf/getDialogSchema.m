function DialogPanel = getDialogSchema(this, manager)
% GETDIALOGSCHEMA Construct the dialog panel for @TransientDataLeaf nodes

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.6 $ $Date: 2004/04/11 00:39:56 $

% First create the GUI panel...
DialogPanel = com.mathworks.toolbox.slestim.data.TransientDataLeaf;

% ... then initialize its data. Will fire listeners.
this.initialize;

% Configure panels
this.configureInputPanel( DialogPanel.getTransientInData,  manager);
this.configureOutputPanel(DialogPanel.getTransientOutData, manager);
this.configureStatePanel( DialogPanel.getTransientICData,  manager);
