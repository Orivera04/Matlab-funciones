function DialogPanel = getDialogSchema(this, manager)
% GETDIALOGSCHEMA Construct the dialog panel

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.5 $ $Date: 2004/04/11 00:40:37 $

% First create the GUI panel
DialogPanel = com.mathworks.toolbox.slestim.view.Viewer;

% Initialize object data
this.initialize

% Get the handles
Handles = this.Handles;

% Add the handle
Handles.PanelManager = explorer.DefaultFolderPanel(DialogPanel, this, manager);

% Store the handles
this.Handles = Handles;
