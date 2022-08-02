function [OK, newTolerance] = toleranceEditDlg(tssf, hParent, varargin)
%TOLERANCEEDITDLG A short description of the function
%
%  OUT = TOLERANCEEDITDLG(IN)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.2 $    $Date: 2004/02/09 08:12:48 $ 

% Check that the tolerance editor doesn't exist
fh = mvf('tssfToleranceEditor');
if ~isempty(fh)
    delete(fh)
end
% Create runtime pointers to hold relevent data
pHandles = xregGui.RunTimePointer;
% Get the system colors
colors = xregGui.SystemColorsDbl;

f = xregGui.figure('visible', 'off',...
    'name', 'Tolerance Editor',...
    'units', 'pixels',...
    'tag', 'tssfToleranceEditor',...
    'pointer', 'watch',...
    'closerequestfcn', {@i_cancel, pHandles},...   
    'windowstyle', 'modal', ...
    'color', colors.CTRL_BACK,...
    'minimumsize', [300 200]);


pHandles.LinkToObject(f);

% Set the default outputs correctly
f.userdata = struct('OK', false);

% Create the layout (based on the data)
[layout, preferedSize] = i_createLayout(f, pHandles, tssf);

% Center the figure on the parent figure
xregcenterfigure(f, preferedSize, hParent);

btOK = xregGui.uicontrol('parent', f,...
	'string', 'OK',...
	'callback', {@i_close pHandles});

btCancel = xregGui.uicontrol('parent', f,...
	'string', 'Cancel',...
	'callback', {@i_cancel pHandles});

btHelp = mv_helpbutton(f, 'xreg_data_toleranceEditor');

f.LayoutManager = xreggridbaglayout(f,...
    'visible', 'off', ...
	'dimension', [2 4],...
	'elements', {layout [] [] btOK [] btCancel [] btHelp},...
	'mergeblock', {[1 1] [1 4]},...
	'gapx', 10,...
	'gapy', 10,...
	'rowsizes', [-1 25],...
	'colsizes', [-1 65 65 65],...
	'border', [10 10 10 1],...
	'packstatus', 'on');

% Set the visibility and wait for it to change
set(f.LayoutManager, 'visible', 'on');
set(f, 'visible', 'on', 'pointer', 'arrow');
waitfor(f, 'visible', 'off');

% Get the return
OK = f.userdata.OK;
newTolerance = i_getTolerances(pHandles);
delete(f);

% --------------------------------------------------------------------
% Function i_createLayout
%
% --------------------------------------------------------------------
function [layout, preferedSize] = i_createLayout(f, pHandles, tssf)

pHandles.info.figure = f;
fh = double(f);

factorNames = globalsignalnames(tssf);
tolerances  = tssf.tolerance;
numFactors = length(factorNames);

% Create the text and edit controls for the array
for i = 1:numFactors
    % Create the Edit Control
    pHandles.info.Edit{i} = xregGui.uicontrol('parent', f,...
        'style', 'edit',...
        'backgroundcolor', 'w',...
        'string', num2str(tolerances(i)),...
        'callback', {@i_checkItsANumber tolerances(i)});
    
    labels{i} = xregGui.labelcontrol('parent', f,...
        'LabelSizeMode', 'Relative',...
        'ControlSizeMode', 'Absolute',...
        'LabelAlignment', 'left',...
        'ControlSize', 100,...
        'LabelSize', 1,...
        'Control', pHandles.info.Edit{i},...
        'String', factorNames{i});
end
    

layout = xreggridbaglayout(f,...
    'dimension', [numFactors + 2, 3],...
    'elements', [repmat({[]}, 1,numFactors + 3)  labels],...
    'rowsizes', [-1 20*ones(1, numFactors) -1],...
    'gap', 5,...
    'colsizes', [-1 200 -1]);

preferedSize = [300 numFactors*25 + 100];

% --------------------------------------------------------------------
%
% --------------------------------------------------------------------
function i_checkItsANumber(src, event, previousValue)
% Get the handle of this object
obj = handle(src);
% What is the current value
value = str2double(obj.string);
% Does the current value convert to a NaN
if isidentical(value, NaN)
    % Set it to it's previous value
    obj.string = num2str(previousValue);
else
    % Update the previous value for next time
    obj.callback{2} = value;
end

% --------------------------------------------------------------------
%
% --------------------------------------------------------------------
function values = i_getTolerances(pHandles)
% Pre-initialse the output
values = zeros(1, length(pHandles.info.Edit));
% Iterate over the edit boxes getting the values in turn
for i = 1:length(values)
    % Convert each in turn
    values(i) = str2double(pHandles.info.Edit{i}.string);
end

% --------------------------------------------------------------------
% Function i_close
%
% --------------------------------------------------------------------
function i_close(src, event, pHandles)
f = pHandles.info.figure;
f.userdata.OK = true;
f.visible = 'off';

% --------------------------------------------------------------------
% Function i_cancel
%
% --------------------------------------------------------------------
function i_cancel(src, event, pHandles)
f = pHandles.info.figure;
f.userdata.OK = false;
f.visible = 'off';
