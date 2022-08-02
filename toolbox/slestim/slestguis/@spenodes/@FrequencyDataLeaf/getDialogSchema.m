function DialogPanel = getDialogSchema(this, manager)
% GETDIALOGSCHEMA Construct the dialog panel for @FrequencyDataLeaf nodes

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/04/11 00:39:15 $

% First create the GUI panel...
DialogPanel = com.mathworks.toolbox.slestim.data.FrequencyDataLeaf;

% ... then initialize its data. Will fire listeners.
this.initialize;

% Configure panels
this.configureInputPanel( DialogPanel.getFrequencyInData,  manager);
this.configureOutputPanel(DialogPanel.getFrequencyOutData, manager);
this.configureStatePanel( DialogPanel.getFrequencyICData,  manager);
