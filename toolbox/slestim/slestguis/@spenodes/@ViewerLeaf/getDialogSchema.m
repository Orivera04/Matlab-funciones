function DialogPanel = getDialogSchema(this, manager)
% GETDIALOGSCHEMA  Construct the dialog panel

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.5 $ $Date: 2004/04/11 00:40:43 $

% First create the GUI panel...
DialogPanel = com.mathworks.toolbox.slestim.view.ViewerLeaf;

% ... then initialize its data. Will fire listeners.
this.initialize;

% Configure panels
this.configurePlotsPanel( DialogPanel.getViewerPlotSetup, manager);
