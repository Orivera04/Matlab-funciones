function configureRunPanel(this, EstimationPanel, manager)
% CONFIGURERUNPANEL 

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.9 $ $Date: 2004/04/16 22:20:32 $

% Ancestor added listener
L = [ handle.listener( handle(EstimationPanel), ...
                       'AncestorAdded', { @LocalUpdateRunPanel } ) ];
set(L, 'CallbackTarget', this);
this.addListeners(L);

% Start button callback
Handles.StartButton = EstimationPanel.getStartButton;
h = handle( Handles.StartButton, 'callbackproperties' );
h.ActionPerformedCallback = { @LocalStartButton, this, manager };

% Settings button callback
h = handle( EstimationPanel.getSettingsButton, 'callbackproperties' );
h.ActionPerformedCallback = { @LocalSettingsButton, this, manager };

% Options button callback
h = handle( EstimationPanel.getOptionsButton, 'callbackproperties' );
h.ActionPerformedCallback = { @LocalOptionsButton, this };

% Plots checkbox callback
Handles.PlotsCheckBox = EstimationPanel.getPlotsCheckBox;
h = handle( Handles.PlotsCheckBox, 'callbackproperties' );
h.ItemStateChangedCallback = { @LocalPlotsCheckBox, this, manager };

% Callback to parameter data table event.
Handles.Table      = EstimationPanel.getIterationTable;
Handles.TableModel = Handles.Table.getModel;

% Configure the text area
Handles.Editor = EstimationPanel.getEditor;
h = handle( Handles.Editor, 'callbackproperties' );
h.HyperlinkUpdateCallback = { @LocalTextAreaCallback, this };

% Store the handles
this.Handles.Estimation = Handles;

% ------------------------------------------------------------------------- %
% Start/stop estimation
function LocalStartButton(hSrc, hData, this, manager)
button   = this.Handles.Estimation.StartButton;
pressed  = button.isSelected;
Explorer = manager.Explorer;

if pressed
  % Start if idle
  if strcmp(this.Estimation.EstimStatus, 'idle')
    Explorer.clearText;
    Explorer.postText('Starting Estimation...');
    % Run estimation
    try
      estimate(this, manager)
    catch
      util = slcontrol.Utilities;
      errordlg(util.getLastError, 'Estimation Error', 'modal');
      button.toggleButton(false);
      beep;
    end
  end
else
  % Stop if running
  if strcmp(this.Estimation.EstimStatus, 'run')
    Explorer.postText('Stopping Estimation...');
    this.Estimation.EstimStatus = 'stop';
  end
end

% ---------------------------------------------------------------------------- %
% Creates and manages optimization and simulation options dialog
function LocalSettingsButton(hSrc, hData, this, manager)
dlg = this.OptionsDialog;
if isempty(dlg) || ~ishandle(dlg)
  dlg = slcontrol.OptionsDialog( this.SimOptions, this.OptimOptions, manager.Explorer );
  this.OptionsDialog = dlg;
end

% Make visible
dlg.show;

% ------------------------------------------------------------------------- %
function LocalPlotsCheckBox(hSrc, hData, this, manager)
views = find(this.up, '-class', 'spenodes.Viewer');

state = hData.getItem.isSelected;
this.Fields.PlotsCheckBox = state;

if isempty(views.down) && state
  str = sprintf( '%s\n%s', ...
                 'There are no views to show the estimation progress.', ...
                 'Would you like to create a new view?' );
  
  import javax.swing.JOptionPane;
  idx = JOptionPane.showConfirmDialog( manager.Explorer, str, ...
                                       'Add View', JOptionPane.YES_NO_OPTION );
  switch idx
  case 0
    % 'Yes': create a view
    leaf = views.addNode;
    manager.Explorer.setSelected( leaf.getTreeNodeInterface );
  case 1
    % 'No': revert back to unchecked state
    this.Fields.PlotsCheckBox = false;
    awtinvoke( this.Handles.Estimation.PlotsCheckBox, 'setSelected', ...
               this.Fields.PlotsCheckBox );
  end
end

% ----------------------------------------------------------------------------- %
% Refresh panel when displayed
function LocalUpdateRunPanel(this, hData)
views = find(this.up, '-class', 'spenodes.Viewer');

% Uncheck if there are no views
if isempty(views.down) && this.Fields.PlotsCheckBox
  this.Fields.PlotsCheckBox = false;
end

awtinvoke( this.Handles.Estimation.PlotsCheckBox, 'setSelected', ...
           this.Fields.PlotsCheckBox );

% ----------------------------------------------------------------------------- %
% Process hyperlinks
function LocalTextAreaCallback(hSrc, hData, this)
if strcmp(hData.getEventType.toString, 'ACTIVATED')
  disp( char(hData.getDescription) )
end

% ---------------------------------------------------------------------------- %
function LocalOptionsButton(hSrc, hData, this)
% Handled in pure Java
