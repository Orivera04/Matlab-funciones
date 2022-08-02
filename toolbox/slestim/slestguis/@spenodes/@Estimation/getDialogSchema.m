function DialogPanel = getDialogSchema(this, manager)
% GETDIALOGSCHEMA Construct the dialog panel

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.6 $ $Date: 2004/04/11 00:38:35 $

% First create the GUI panel
DialogPanel = com.mathworks.toolbox.slestim.estimation.Estimation;

% Initialize object data
this.initialize

% Get the handles
Handles = this.Handles;

% Add the handle
exclude = { 'spenodes.Viewer' };
Handles.PanelManager = explorer.DefaultFolderPanel( DialogPanel, this, ...
                                                    manager, exclude );

% Store the handles
this.Handles = Handles;
