function [OK, SS] = xregChangeUnit(SS)
%XREGCHANGEUNIT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 08:20:56 $

scrpos = get(0,'screensize');

f = xregfigure('visible', 'off',...
   'units','pixels',...
   'position',[20 scrpos(4)-750 400 200],...
   'Name', 'Unit Conversion',...
   'tag', 'UnitConversion',...
   'closerequestfcn',{@i_close},...   
   'windowstyle', 'modal',...
   'color',get(0,'defaultuicontrolbackgroundcolor'));

fh = double(f);

% Runtime pointer that holds the sweepset being changed
pSS = xregGui.RunTimePointer(SS);
pSS.LinkToObject(fh);

editorText = xregGui.uicontrol('style', 'text',...
	'parent', fh,...
	'horizontalAlignment', 'right',...
	'string', 'Convert to :');

editor = xregGui.juniteditor(fh,...
	'editorType', 'convert',...
	'displayAllTypes', 'off');

str = i_getNameList(SS);

varList = xregGui.uicontrol('style', 'listbox',...
	'parent', fh,...
	'backgroundcolor', [1 1 1],...
	'string', str);;

editor.unitConvertCallback = {@i_unitConverted, pSS, varList};
varList.callback = {@i_variableSelected, pSS, editor};

grid = xreggridbaglayout(fh,...
	'dimension', [1 3],...
	'elements', {varList editorText editor},...
	'gapx', 10,...
	'colsizes', [-1 70 130],...
   'packstatus','off');

frame = xregframetitlelayout(fh,...
	'Title', 'Variables',...
	'center', grid);

btOK = xregGui.uicontrol('parent', fh,...
	'string', 'OK',...
	'callback', {@i_ok, fh});

btCancel = xregGui.uicontrol('parent', fh,...
	'string', 'Cancel',...
	'callback', {@i_cancel, fh});

mainLayout = xreggridbaglayout(fh,...
	'dimension', [2 3],...
	'elements', {frame [] [] btOK [] btCancel},...
	'mergeblock', {[1 1] [1 3]},...
	'gapx', 10,...
	'gapy', 10,...
	'colsizes', [-1 65 65],...
	'rowsizes', [-1 25],...
	'border', [5 5 5 5]);

f.LayoutManager = mainLayout;
set(mainLayout,'packstatus','on');

f.visible = 'on';
i_variableSelected(varList, [], pSS, editor);

waitfor(fh, 'visible', 'off');
OK = 0;
switch f.userdata
case 'ok'
	SS = pSS.info;
	OK = 1;
end
delete(fh);


%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function str = i_getNameList(SS, index)
varNames  = get(SS, 'name');
varUnits  = get(SS, 'units');
if nargin > 1
	varNames = varNames(index);
	varUnits = varUnits(index);
end
varSpace1 = {' ['};
varSpace2 = {']'};
% Convert a cell array of junit objects to a vector
isJunit   = cellfun('isclass', varUnits, 'junit');
junits = varUnits(isJunit);
charUnit = char([junits{:}]);
if ~iscell(charUnit)
	charUnit = {charUnit};
end
varUnits(isJunit) = charUnit;

str = strcat(varNames, varSpace1, varUnits, varSpace2);

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_variableSelected(src, event, pSS, editor)
varIndex = get(src, 'value');
if varIndex > 0
	units = get(pSS.info, 'units');
	unit = units{varIndex};
	if isa(unit, 'junit')
		editor.unit = unit;
	else
		editor.unit = junit;
	end
	editor.userdata = varIndex;
	if isempty(editor.unit)
		editor.enable = 'off';
	else
		editor.enable = 'on';
	end
end

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_unitConverted(editor, event, pSS, varList)
varIndex = editor.userdata;
SS = pSS.info;
SS = convert(SS, varIndex, event.newUnit);
pSS.info = SS;
% Create the new string array
newStr = i_getNameList(SS, varIndex);
str = varList.string;
str(varIndex) = newStr;
% % Get ListboxTop before because setting the string changes it
listBoxTop = varList.ListBoxTop;
varList.string = str;
varList.ListBoxTop = listBoxTop;

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_ok(src, event, fh)
set(fh, 'userdata', 'ok', 'visible', 'off');

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_cancel(src, event, fh)
set(fh, 'userdata', 'cancel', 'visible', 'off');

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_close(fh, event)
set(fh, 'userdata', 'cancel', 'visible', 'off');