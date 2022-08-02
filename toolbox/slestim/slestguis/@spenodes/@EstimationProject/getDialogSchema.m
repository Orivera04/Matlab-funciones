function DialogPanel = getDialogSchema(this, manager)
% GETDIALOGSCHEMA Construct the dialog panel for EstimationProject nodes

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.8 $ $Date: 2004/04/11 00:39:00 $

% First create the GUI panel...
DialogPanel = com.mathworks.toolbox.slestim.project.EstimationProject;

% ... then initialize its data.  Will fire listeners.
this.initialize;

% Open button callback
h = handle( DialogPanel.getOpenButton, 'callbackproperties' );
h.ActionPerformedCallback =  { @LocalOpenButtonClicked, this };

% Update button callback
h = handle( DialogPanel.getUpdateButton, 'callbackproperties' );
h.ActionPerformedCallback =  { @LocalUpdateButtonClicked, this };

% Title field callback
h = handle( DialogPanel.getTitleField, 'callbackproperties' );
h.FocusLostCallback = { @LocalTitleUpdate, this };

% Subject field callback
h = handle( DialogPanel.getSubjectField, 'callbackproperties' );
h.FocusLostCallback = { @LocalSubjectUpdate, this };

% Author field callback
h = handle( DialogPanel.getAuthorField, 'callbackproperties' );
h.FocusLostCallback = { @LocalAuthorUpdate, this };

% Company field callback
h = handle( DialogPanel.getCompanyField, 'callbackproperties' );
h.FocusLostCallback =  { @LocalCompanyUpdate, this };

% Description field callback
h = handle( DialogPanel.getDescriptionArea, 'callbackproperties' );
h.FocusLostCallback = { @LocalDescriptionUpdate, this };

% Initialize fields & nodes
LocalInitializeFields(this, DialogPanel)

% ---------------------------------------------------------------------------- %
function LocalOpenButtonClicked(hSrc, hData, this)
try
  open_system(this.Model);
catch
  util = slcontrol.Utilities;
  errmsg = util.getLastError;
  errordlg(errmsg, 'Model Error', 'modal')
  return
end

% ---------------------------------------------------------------------------- %
function LocalUpdateButtonClicked(hSrc, hData, this)
try
  open_system(this.Model);
catch
  util = slcontrol.Utilities;
  errmsg = util.getLastError;
  errordlg(errmsg, 'Task Update Error', 'modal')
  return
end
this.firePropertyChange( 'MODEL_CHANGED' );

% ---------------------------------------------------------------------------- %
function LocalTitleUpdate(hSrc, hData, this)
this.Fields.Title = char( hData.getSource.getText );
this.setDirty;

function LocalSubjectUpdate(hSrc, hData, this)
this.Fields.Subject = char( hData.getSource.getText );
this.setDirty;

function LocalAuthorUpdate(hSrc, hData, this)
this.Fields.Author = char( hData.getSource.getText );
this.setDirty;

function LocalCompanyUpdate(hSrc, hData, this)
this.Fields.Company = char( hData.getSource.getText );
this.setDirty;

function LocalDescriptionUpdate(hSrc, hData, this)
this.Fields.Description = char( hData.getSource.getText );
this.setDirty;

% ---------------------------------------------------------------------------- %
function LocalInitializeFields(this, DialogPanel)
% Initialize the panel data
strs = { this.Fields.Title; ...
         this.Fields.Subject; ...
         this.Fields.Author; ...
         this.Fields.Company; ...
         this.Fields.Description; ...
         this.Model };
DialogPanel.initWidgets( strs );
