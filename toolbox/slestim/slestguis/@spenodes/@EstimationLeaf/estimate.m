function estimate(this, manager)
% ESTIMATE Callback for start button

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.5 $ $Date: 2004/04/19 01:33:01 $

hEst = this.Estimation;

% Get the handle to the explorer frame
Explorer = manager.Explorer;
editor = this.Handles.Estimation.Editor;
editor.setText('')

% Make sure that the model can be compiled
LocalValidateModel(this);

% Prepare estimation
LocalConfigureEstimation(this);

% New listener.  No need to store since it needs to be destroyed when done.
L = [ handle.listener(hEst, 'EstimUpdate', ...
                      @(x,y) LocalEstimInfo(this, manager)); ...
      handle.listener(hEst, hEst.findprop('EstimStatus'), ...
                      'PropertyPostSet', @(x,y) LocalEnable(this, y)) ];

% Start estimation
try
  OptimInfo = estimate(hEst);
  editor.append( ['<BR>' OptimInfo.Output.message] )
  delete(L);
catch
  % Clean up after error
  hEst.EstimStatus = 'error';
  % Post error
  if ~strcmp(lasterr, 'Interrupt')
    util = slcontrol.Utilities;
    errordlg(util.getLastError, 'Estimation Error', 'modal');
  end
  beep;
  
  % Return to idle
  hEst.EstimStatus = 'idle';
  delete(L);
  return
end

Explorer.postText('Estimation completed.');

% Update parameter/state values
LocalUpdateVariables(this);
beep;

% ---------------------------------------------------------------------------- %
function LocalValidateModel(this)
Model = this.Estimation.Model;
OrigSettings = LocalApplySettings(Model, this.SimOptions);
try
  feval(this.Estimation.Model,[],[],[],'compile');
  % Terminate
  feval(Model,[],[],[],'term');
  LocalRestoreSettings(Model, OrigSettings);
catch
  LocalRestoreSettings(Model, OrigSettings);
  rethrow(lasterror)
end

% ---------------------------------------------------------------------------- %
function LocalConfigureEstimation(this)
% Evaluate numerical estimation object and its numerical properties.
evalForm(this);

% Generate report
LocalReportGenerator(this)

% ---------------------------------------------------------------------------- %
% Fill-in the text area in the GUI with useful estimation information.
function LocalReportGenerator(this)
editor = this.Handles.Estimation.Editor;
hEst   = this.Estimation;

% Estimation type
type = this.ExperimentType;
idxs = [ this.ExperimentList{type}.Selected ];
SelectedExperimentList = this.ExperimentList{type}(idxs);

switch type
case 1
  editor.append( '<B>Performing transient estimation...</B><BR>' )
case 2
  editor.append( '<B>Performing steady-state estimation...</B><BR>' )
case 3
  editor.append( '<B>Performing frequency-domain estimation...</B><BR>' )
end

% Experiments
str = '<B>Active experiments:</B> ';
names = {'None'};
if ~isempty(SelectedExperimentList)
  names = { SelectedExperimentList.Name }';
  names(1:end-1) = regexprep(names(1:end-1), '(.*$)', '$1, ');
end
editor.append( [{str}; names; {'<BR>'}] )

% Variables
str   = '<B>Estimated parameters:</B> ';
names = {'None'};
if ~isempty(hEst.Parameters)
  estparams = find( hEst.Parameters, '-function', 'Estimated', @(x) any(x(:)) );
  if ~isempty(estparams)
    names = get( estparams, {'Name'} );
    names(1:end-1) = regexprep(names(1:end-1),  '(.*$)', '$1, ');
  end
end
editor.append( [{str}; names; {'<BR>'}] )

% Post to info area
for ct = 1:size(hEst.States, 2)
  expname = SelectedExperimentList(ct).Name;
  str   = sprintf( '<B>Estimated States for experiment <I>%s</I>:</B> ', expname);
  names = {'None'};

  eststates = find( hEst.States(:,ct), '-function', 'Estimated',@(x) any(x(:)) );
  if ~isempty(eststates)
    names = get( eststates, {'Block'} );
    names = regexprep( names, '\n\r?', ' ');
    names(1:end-1) = regexprep(names(1:end-1),  '(.*$)', '$1<BR>');
    str = [str '<BR>'];
  end
  editor.append( [{str}; names; {'<BR>'}] )
end

% ---------------------------------------------------------------------------- %
% Update parameters/states in the GUI.
function LocalUpdateVariables(this)
% Update parameters
source = this.Estimation.Parameters;
AllParameters = this.Parameters;
for k = 1:length(source)
  AllParameters(k).Value = mat2str(source(k).Value, 5);
end

% Update the parameter table data
table = getParameterData(this);
model = this.Handles.Parameter.TableModel;
model.setData(table);
model.tableRowsUpdated(0, length(source)-1);

% Update states
source = this.Estimation.States;
type = this.ExperimentType;
idxs = [ this.ExperimentList{type}.Selected ];
AllStates = this.States{type};
if ~isempty(AllStates)
  SelectedStates = AllStates(:, idxs);
else
  SelectedStates = [];
end

for k = 1:length(source(:))
  SelectedStates(k).Value = mat2str(source(k).Value, 5);
end

% Update the state table data
selected = this.Handles.State.DataSetCombo.getSelectedIndex + 1;
if selected > 0
  table = getStateData(this, selected);
else
  table = [];
end
model = this.Handles.State.TableModel;
model.setData(table);
model.tableRowsUpdated(0, length(source)-1);

% ---------------------------------------------------------------------------- %
function LocalEstimInfo(this, manager)
h = this.Estimation;

if strcmp(this.Estimation.EstimStatus, 'run')
  EstimInfo = h.EstimInfo;
  data = { num2str(EstimInfo.Iteration(end), 5), ...
           num2str(EstimInfo.FCount(end), 5), ...
           num2str(EstimInfo.Cost(end), 5), ...
           num2str(EstimInfo.StepSize(end), 5), ...
           EstimInfo.Procedure{end} };
  this.Handles.Estimation.TableModel.setTableText(data);
  
  %% Get the handle to the explorer frame
  Explorer = manager.Explorer;
  Explorer.postText( ['Iteration ' data{1} ' complete'])
end

% ---------------------------------------------------------------------------- %
function LocalEnable(this, hData)
button = this.Handles.Estimation.StartButton;
switch hData.NewValue
case 'run'
  % no action
case 'idle'
  button.toggleButton(false);
end

% --------------------------------------------------------------------------
function s0 = LocalApplySettings(Model, s)
% Applies sim options to Model after saving current options
Dirty = get_param(Model, 'Dirty');
s = get(s);
if strcmp(s.StartTime, 'auto')
  s.StartTime = get_param(Model, 'StartTime');
end
if strcmp(s.StopTime, 'auto')
  s.StopTime = get_param(Model, 'StopTime');
end

% Save original settings
Fields = fieldnames(s);
s0 = s;
for ct = 1:length(Fields)
  f = Fields{ct};
  s0.(f) = get_param(Model, f);
  set_param(Model, f, s.(f))
end
s0.Dirty = Dirty;

% --------------------------------------------------------------------------
function LocalRestoreSettings(Model, s0)
% Restore original model options
Fields = fieldnames(s0);
for ct = 1:length(Fields)
  f = Fields{ct};
  set_param(Model, f, s0.(f))
end
