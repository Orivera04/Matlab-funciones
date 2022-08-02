function DialogPanel = getDialogSchema(this, manager)
% GETDIALOGSCHEMA Construct the dialog panel

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/04/11 00:39:07 $

% First create the GUI panel
DialogPanel = com.mathworks.toolbox.slestim.data.FrequencyData;

% Initialize object data
this.initialize

% Get the handles
Handles = this.Handles;

% Add the handle
Handles.PanelManager = explorer.DefaultFolderPanel(DialogPanel, this, manager);

% Store the handles
this.Handles = Handles;
