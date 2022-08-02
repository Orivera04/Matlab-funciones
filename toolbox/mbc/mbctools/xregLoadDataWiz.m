function varargout = xregLoadDataWiz(action, varargin)
% XREGLOADDATAWIZ

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.11.4.3 $  $Date: 2004/02/09 08:21:02 $


switch lower(action)
case 'cardone'
	[varargout{1:nargout}] = i_createCardOne(varargin{:});
case 'cardtwo'
	[varargout{1:nargout}] = i_createCardTwo(varargin{:});
case 'cardthree'
	[varargout{1:nargout}] = i_createCardThree(varargin{:});
end
%------------------------------------------------------------------------
% CARD ONE FUNCTIONS BELOW
%------------------------------------------------------------------------

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function layout = i_createCardOne(fh, iFace, localData)

if isa(fh, 'xregcontainer')
	layout = fh;
	layoutUD = get(layout, 'userdata');
else
	p = getpref(mbcprefs('mbc'), 'DataLoading');
	% Find valid data import functions
	validFunctions = [];
	for i = 1:length(p.DataImportFunctions)
		func = p.DataImportFunctions(i).function;
		if strcmp(class(func), 'function_handle')
			% Convert function handles to chars
			func = func2str(func);
		end
		% Does this function exist as an m, p or mex file?
		funcExist = exist(func);
		if funcExist == 2 | funcExist == 3 | funcExist == 6
			% If so add it to the list of valid functions
			validFunctions = [validFunctions i];
		end
	end
	layoutUD.importFcns = p.DataImportFunctions(validFunctions);
	
	txFilename = xregGui.uicontrol('parent', fh,...
		'style', 'text',...
		'horizontal','left',...
		'string', 'Filename :');
	
	txFileType =  xregGui.uicontrol('parent', fh,...
		'style', 'text',...
		'horizontal','left',...
		'string', 'Open As :');
	
	edFilename = xregGui.uicontrol('parent', fh,...
		'style', 'edit',...
		'horizontal','left',...
		'callback', {@i_edFilenameChanged, iFace},...
		'background', [1 1 1]);
	
	cbFileType = xregGui.uicontrol('parent', fh,...
		'style', 'popup',...
		'string', {'Auto' layoutUD.importFcns.fileType},...
		'callback', {@i_cbFileTypeChanged, iFace},...
		'background', [1 1 1]);
	
	btFilename = xregGui.uicontrol('parent', fh,...
		'string', '...',...
		'callback', {@i_btFilenameClicked, iFace});
	
	centerLayout = xreggridbaglayout(fh,...
		'dimension', [2 3],...
		'elements', {txFilename txFileType edFilename cbFileType btFilename []},...
		'rowsizes', [20 20],...
		'colsizes', [70 -1  20],...
		'gapy', 5,...
		'gapx', 5);
	
	layout = xreggridbaglayout(fh,...
		'dimension', [3 1],...
		'elements', {[] centerLayout []},...
		'rowsizes', [-1 60 -1],...
		'colsizes', [-1],...
		'border', [30 0 30 0],...
		'rowratios',[.5 0 .5]);
	
	layoutUD.edFilename = edFilename;
	layoutUD.cbFileType = cbFileType;
	layoutUD.mergeSweepset = [];
	
	layoutUD.nextFcn    = @i_cardOneNext;
end

if nargin > 2
	layoutUD.mergeSweepset = localData.mergeSweepset;
end
i_cardOneUpdate(layoutUD, iFace);
set(layout, 'userdata', layoutUD);

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_btFilenameClicked(btFilename, event, iFace)
layoutUD = feval(iFace.getCardUserdata);

cdir = cd(xregGetDefaultDir('Data'));
% Get the returned index from the file open dialog
[filename, pathname, filterindex] = uigetfile(vertcat({'*.*' 'All files (*.*)'}, layoutUD.importFcns.filterSpec), 'Select a file to import');
cd(cdir);
% Check if the user cancelled the operation
if filename == 0
    return
end
filename = fullfile(pathname, filename);
% Has the user selected the same filename again?
if isequal(filename, layoutUD.edFilename.string)
    return
end
layoutUD.edFilename.string = filename;
% Has the user selected a particular file type?
if filterindex > 1
    layoutUD.cbFileType.value = filterindex;
end
i_cardOneUpdate(layoutUD, iFace);

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_edFilenameChanged(edFilename, event, iFace)
layoutUD = feval(iFace.getCardUserdata);
i_cardOneUpdate(layoutUD, iFace);

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_cbFileTypeChanged(cbFileType, event, iFace)

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_cardOneUpdate(layoutUD, iFace)
filename = get(layoutUD.edFilename, 'string');
fileExists = exist(filename) == 2;
feval(iFace.setNextButton,   fileExists);
feval(iFace.setFinishButton, 'off');

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function [nextCardID, localData] = i_cardOneNext(layoutUD, iFace)
% Only set when sure that this has completed sucessfully
nextCardID = [];
localData  = [];
% Get the filename
filename = get(layoutUD.edFilename, 'string');
fileTypeValue = i_getCardOneFileType(layoutUD);
% Check that the fileTypeValue is valid
if fileTypeValue < 1
	return
end
% Call the data loading function with the load structure
out = sweepset2struct(sweepset);
out.filename = filename;
try
    [OK, msg, out] = feval(layoutUD.importFcns(fileTypeValue).function, filename, out);
catch
    OK = 0;
    msg = 'Data load failed due to unexpected error';
end

if ~OK
    if ~isempty(msg)
		% The Data Loading Function returned some sort of error message
		uiwait(errordlg(msg, 'Data Loading Error', 'modal'));
    end
    return
end

localData.filename = out.filename;
localData.newSweepset = struct2sweepset(sweepset, out);
localData.mergeSweepset = layoutUD.mergeSweepset;
nextCardID = @i_createCardTwo;

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function fileTypeValue = i_getCardOneFileType(layoutUD)

fileTypeValue = get(layoutUD.cbFileType, 'value');
filename = get(layoutUD.edFilename, 'string');
[p, n, ext] = fileparts(filename);

if fileTypeValue == 1
    % Automatic detection of file type
    filterSpecs = vertcat(layoutUD.importFcns.filterSpec);
    filters = filterSpecs(:,1);
    found = [];
    for i = 1:length(filters)
        ind = findstr(lower(ext), lower(filters{i}));
        % Do any of these found indicies completely match ext. Is this the last extension in the
        % list or is it immediately followed by a ';'
        nextCharInd = ind + length(ext);
        for j = 1:length(ind)
            if nextCharInd(j) <= length(filters{i}) & filters{i}(nextCharInd(j)) ~= ';'
                % If it is not the last ext or followed by ';' then remove from the found list
                ind(j) = [];
            end
        end
        if ~isempty(ind) 
            found = [found i];
        end
    end
    % Can we decide which sort of file we are opening?
    if isempty(found)
        uiwait(errordlg(['Automatic file detection failed - unknown file type. '...
                'Please select appropriate file type from drop down list'], 'Data Loading Error',...
            'modal'));
		fileTypeValue = 0;
        return
    end
    if length(found) > 1
        foundFirstStr = layoutUD.importFcns(found(1)).fileType;
        answer = questdlg(['Assuming file to be a ' foundFirstStr '. To select a '...
                'different file type use the drop down box'], 'Ambiguous Data File Type', ...
            'OK', 'Cancel', 'OK');
        if strcmp(lower(answer), 'cancel')
			fileTypeValue = 0;
            return
        end
    end
    fileTypeValue = found(1); 
else
    % Manual file type detection, subtract 1 from the Auto label
    fileTypeValue = fileTypeValue - 1;
end

%------------------------------------------------------------------------
% CARD TWO FUNCTIONS BELOW
%------------------------------------------------------------------------

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function layout = i_createCardTwo(fh, iFace, localData)
% Have we been called to create the layout or simply update?
if isa(fh, 'xregcontainer')
	layout = fh;
	layoutUD = get(layout, 'userdata');
else
	txRecords = xregGui.uicontrol('parent', fh,...
		'style', 'text',...
		'string', '',...
		'visible', 'off',...
		'horizontal', 'left');
	
	txFilename = xregGui.uicontrol('parent', fh,...
		'style', 'list',...
		'string', '',...
		'visible', 'off',...
		'horizontal', 'left');
		
    lvVariables = xregdatagui.sweepsetlist('Parent', fh,...
        'Editable', true);
    
    lvVariables.setColumnHeaders({@min @max @mean @std}, {'Min', 'Max', 'Mean', 'Std. Dev'}, [65 65 65 65]);

	layout = xreggridbaglayout(fh,...
		'dimension', [2 2],...
		'elements', {txRecords  lvVariables txFilename []},...
		'mergeblock', {[2 2] [1 2]},...
		'rowsizes', [40 -1],...
		'colsizes', [200 -1],...
		'border', [10 0 10 10],...
		'gapy', 5,...
		'gapx', 5);
	
	layoutUD.txRecords     = txRecords;
	layoutUD.txFilename    = txFilename;
	layoutUD.lvVariables   = lvVariables;
	
	layoutUD.nextFcn       = @i_cardTwoNext;
	layoutUD.finishFcn     = @i_cardTwoFinish;
	
	layoutUD.filename      = '';
	layoutUD.mergeSweepset = [];
	layoutUD.mergeAvail    = 0;
    layoutUD.lvVariables.sweepset = sweepset;
end

if nargin > 2
	layoutUD.mergeSweepset = localData.mergeSweepset;
	layoutUD.filename      = localData.filename;
	layoutUD.mergeAvail    = ~isempty(layoutUD.mergeSweepset);
    layoutUD.lvVariables.sweepset = localData.newSweepset;
end

i_cardTwoUpdate(layoutUD, iFace);
set(layout, 'userdata', layoutUD);

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_cardTwoUpdate(layoutUD, iFace)
feval(iFace.setFinishButton, ~layoutUD.mergeAvail);
feval(iFace.setNextButton, layoutUD.mergeAvail);
% Get the sweepset from the listview
ss = layoutUD.lvVariables.sweepset;
% Set text and variables information
set(layoutUD.txRecords, 'string', ['Imported ' num2str(size(ss,1)) ' records and ' num2str(size(ss,2)) ...
		' variables from files :']);
set(layoutUD.txFilename, 'string', layoutUD.filename);

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_cardTwoFinish(layoutUD, iFace)
outputUD.sweepset = layoutUD.lvVariables.sweepset;
outputUD.filename = layoutUD.filename;
feval(iFace.setOutputData, outputUD);

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function [nextCardID, localData] = i_cardTwoNext(layoutUD, iFace)
localData.filename      = layoutUD.filename;
localData.newSweepset   = layoutUD.lvVariables.sweepset;
localData.mergeSweepset = layoutUD.mergeSweepset;
nextCardID = @i_createCardThree;

%------------------------------------------------------------------------
% CARD THREE FUNCTIONS BELOW
%------------------------------------------------------------------------

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function layout = i_createCardThree(fh, iFace, localData)
% Have we been called to create the layout or simply update?
if isa(fh, 'xregcontainer')
	layout = fh;
	layoutUD = get(layout, 'userdata');
else
	txSelect = xregGui.uicontrol('parent', fh,...
		'style', 'text',...
		'string', 'Select appropriate merge action',...
		'visible', 'off',...
		'horizontal', 'left');
	
	rbGroup = xregGui.rbgroup('parent', fh,...
		'nx', 1,...
		'ny', 3,...
		'string', {'Merge extra records';'Merge extra channels';'Overwrite old data'});
	
	layout = xreggridbaglayout(fh,...
		'dimension', [3 1],...
		'elements', {txSelect rbGroup []},...
		'rowsizes', [20 60 -1],...
		'border', [10 0 10 10],...
		'gapy', 5,...
		'gapx', 5);
	
	layoutUD.rbGroup       = rbGroup;
	
	layoutUD.nextFcn       = @i_cardThreeNext;
	
	layoutUD.filename      = '';
	layoutUD.newSweepset   = sweepset;
	layoutUD.mergeSweepset = [];
end

if nargin > 2
	layoutUD.newSweepset   = localData.newSweepset;
	layoutUD.mergeSweepset = localData.mergeSweepset;
	layoutUD.filename      = localData.filename;
end
set(layout, 'userdata', layoutUD);
% Enable the next button
feval(iFace.setNextButton, 'on');
feval(iFace.setFinishButton, 'off');

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function [nextCardID, localData] = i_cardThreeNext(layoutUD, iFace)
% Only set when sure that this has completed sucessfully
nextCardID = [];

% Attempt selected merge
mergeType = layoutUD.rbGroup.selected;
newSS     = layoutUD.newSweepset;
mergeSS   = layoutUD.mergeSweepset;
try
	switch mergeType
	case 1 
		[localData.newSweepset, OK, msg] = append(mergeSS, newSS);
		localData.filename = strvcat(get(mergeSS, 'filename'), layoutUD.filename);
	case 2
		% Align merge needs common variable names
		commonNames = intersect(get(newSS, 'name'), get(mergeSS, 'name'));
		[localData.newSweepset, OK, msg] = align(mergeSS, newSS, commonNames);
		localData.filename = strvcat(get(mergeSS, 'filename'), layoutUD.filename);
	case 3
		OK = 1;
		localData.newSweepset = newSS;
		localData.filename = layoutUD.filename;
	otherwise
		return
	end
catch
	OK = 0;
	msg = 'Merge failed due to unexpected error';
end

if ~OK
    if ~isempty(msg)
		% The Data Loading Function returned some sort of error message
		uiwait(errordlg(msg, 'Data Loading Error', 'modal'));
    end
    return
end

localData.mergeSweepset = [];
nextCardID = @i_createCardFour;

%------------------------------------------------------------------------
% CARD FOUR FUNCTIONS BELOW
%------------------------------------------------------------------------

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function layout = i_createCardFour(varargin)
layout = i_createCardTwo(varargin{:});
