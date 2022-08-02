function varargout = xregExcel(action, varargin)
%XREGEXCEL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.3 $  $Date: 2004/02/09 08:20:59 $



persistent excelVer;

switch lower(action)
case 'start'
	[varargout{1} excelVer] = i_startExcel;
   varargout{2} = excelVer;
case 'prepare'
	if excelVer == 95
		i_preparePage95(varargin{:});
	else
		i_preparePage97(varargin{:});
	end	
case 'read'
	if excelVer == 97
		[varargout{1:nargout}] = i_readExcelSheet97(varargin{:});
	end
case 'export'
	if excelVer == 97
		i_exportExcelSheet97(varargin{:});
	end	
case {'cancel' 'close'}
	i_closeExcel(varargin{:})
end

% --------------------------------------------------------------------
%
% --------------------------------------------------------------------
function [excelStruct, excelVer] = i_startExcel
% Create a new worksheet. Doing it this way ensures that all calls to
% excel.sheet go to the same COM server so only one COM instance of EXCEL
% is instanciated

svr = actxserver('excel.application');
% Which version of excel are we attached to?
try
   svr.UserControl = true;
   excelVer = 97;   % Office 97/2000
   bks = svr.workbooks.Add;   
catch
   invoke(svr,'quit');
   release(svr);
   bks = actxserver('excel.sheet');
   excelVer = 95;   % Excel 95
end
excelStruct.dataBook = bks;

% --------------------------------------------------------------------
%
% --------------------------------------------------------------------
function i_preparePage95(excelStruct)
activeBook = excelStruct.dataBook;
% Make the application visible
server = get(activeBook, 'application');
server.visible = 1;
release(server);

activeSheet = get(activeBook, 'activeSheet');
% Set the name of the Active Sheet
set(activeSheet,'name','MBC Data');
h = activeSheet.Range('1:2');
h.Interior.ColorIndex = 24;
h.Borders.Colorindex = 1;
release(h);

h = activeSheet.Columns.Range('a:a');
set(h.interior,'colorindex',-1);
set(h.font,'bold',1);
set(h.font,'size',12);
release(h);

h = activeSheet.Range('a1:a2');
set(h.interior,'colorindex',17);
set(h.font,'bold',1);
set(h.font,'size',12);
release(h);

chan = ddeinit('excel','MBC Data');
ddepoke(chan,'r1c1','Name:');
ddepoke(chan,'r2c1','Unit:');
ddepoke(chan,'r3c1','Data:');
ddeterm(chan);

% --------------------------------------------------------------------
%
% --------------------------------------------------------------------
function i_preparePage97(excelStruct)
% Note extra calls to release in this code ensure that no activeX handle are 
% left hanging around, which would crash EXCEL when it is closed
activeBook = excelStruct.dataBook;
% Make the application visible
server = get(activeBook, 'application');

activeSheet = get(activeBook, 'activeSheet');
% Set the name of the Active Sheet
set(activeSheet,'name','MBC Data');

% Get the first two rows
r12 = get(activeSheet,'range','1:2');
set(r12.interior,'colorindex', 24);
set(r12.borders, 'colorindex', 0);
release(r12);

col1 = get(activeSheet,'columns',1);
set(col1.font, 'bold', 1);
set(col1.font,'size',12);
release(col1);

c12 = get(activeSheet, 'range', 'A1:A2');
set(c12.interior, 'colorindex', 17);
set(c12.font,'bold',1);
set(c12.font,'size',12);
release(c12);

c13 = get(activeSheet,'range','A1:A3');
c13.value = {'Name:'; 'Unit:'; 'Data:'};
release(c13);

set(server, 'visible', 1);

release(activeSheet);
release(server);

% --------------------------------------------------------------------
%
% --------------------------------------------------------------------
function [names, units, doubleData] = i_readExcelSheet97(excelStruct, worksheet)

% Read from the excelStruct active sheet
USE_EXCEL_STRUCT = nargin == 1;
if USE_EXCEL_STRUCT
    worksheet = get(excelStruct.dataBook, 'activeSheet');
end
% Is the user editing the worksheet
try
	a = get(worksheet);
catch
	error('The user has locked the worksheet for editing');
end

currentRange = worksheet.UsedRange.CurrentRegion;

if USE_EXCEL_STRUCT
    release(worksheet);
end

BLOCK_SIZE = 400;

% Getting data from excel can introduce activeX warnings
warn = warning;
warning off;

% Does A1 contain the string 'Name:', if so then data starts in column B
% So remove first column of data by resizeing and offsetting the range
A1 = get(currentRange, 'Resize', 1, 1);
if strcmp(A1.value, 'Name:')
	currentRange = get(currentRange, 'Offset', 0, 1);
    currentRange = get(currentRange, 'Resize', [], currentRange.Columns.Count - 1);
end

[allData, currentRange, blockHasMoreData] = i_getBlockOfRange(currentRange, BLOCK_SIZE);

% Are any of the names actually numbers?
names = allData(1,:);
numIndex = find(cellfun('isclass', names, 'double'));
for i = numIndex
	names{i} = num2str(names{i});
end
% Read in possible names and units information
names = xregdeblank(names);
units = xregdeblank(allData(2,:));
warning(warn);

rowStart = 3;
% Does any of the units line contain a string?
if ~any(cellfun('isclass',units,'char'))
	% If not then all units are empty
	units(1:length(units)) = {''};
	rowStart = 2;
end
% Does any of the names line not contain a string?
nameNotString = ~cellfun('isclass',names,'char');
if any(nameNotString)
	% Give any name that isn't a string the default names VAR
	% Note that the sweepset constructor will remove any variable name duplication
	names(nameNotString) = {'VAR'};
end
% Do we have any variable names?
if all(nameNotString)
	rowStart = 1;
end
% Pre-initialise the double data
doubleData = [];
blockData = allData(rowStart:end,:);
% This is really a DO - WHILE loop but to code in MATLAB we are going to
% have to use a while true if condition break end end contruct. This loop
% loads the data in chunks to avoid excessive memory useage.
while true
    % Convert to a double matrix so make sure everything is a double
    dataNotDouble = ~cellfun('isclass', blockData, 'double') | cellfun('isempty', blockData);
    blockData(dataNotDouble) = {NaN};
    % Note that blockDoubleData = [blockData{:}] is v. slow for large cells
    blockDoubleData = zeros(size(blockData));
    for i = 1:numel(blockData)
        blockDoubleData(i) = blockData{i};
    end
    % Concatenate this data onto the whole
    doubleData = [doubleData ; blockDoubleData];
    if ~blockHasMoreData
        break
    end
    [blockData, currentRange, blockHasMoreData] = i_getBlockOfRange(currentRange, BLOCK_SIZE);
end

release(currentRange);
%ss = sweepset('Variable', 1:length(names) , '' , names ,'' , units , '' ,doubleData );
% --------------------------------------------------------------------
%
% --------------------------------------------------------------------
function [data, range, hasMoreData] = i_getBlockOfRange(range, numRowsRequested)
% How many rows in the range
numRows = range.rows.count;
% Should we get a smaller range
if numRows > numRowsRequested
    reducedRange = get(range, 'Resize', numRowsRequested);
    hasMoreData = true;
    range = get(range, 'Offset', numRowsRequested);
    range = get(range, 'Resize', numRows - numRowsRequested);
else
    reducedRange = range;
    hasMoreData = false;
end
% Get the data from the reduced range
data = reducedRange.value;

% --------------------------------------------------------------------
%
% --------------------------------------------------------------------
function i_exportExcelSheet97(excelStruct, SS);
if size(SS, 2) > 255
	waitfor(warndlg('Excel only supports data with 255 variables. Data reduction will occur', 'Excel warning', 'modal'));
	SS = SS(:, 1:255);
end

i_preparePage97(excelStruct);

worksheet = excelStruct.dataBook.activesheet; 

names = get(SS, 'name');
units = get(SS, 'units');
charUnits = char([units{:}]);
data = double(SS);

numCols = length(names);
nameRangeStart = get(worksheet, 'cells', 1, 2);
nameRangeEnd = get(worksheet, 'cells', 1, numCols+1);
unitRangeStart = get(worksheet, 'cells', 2, 2);
unitRangeEnd = get(worksheet, 'cells', 2, numCols+1); 
dataRangeStart = get(worksheet, 'cells', 3, 2);
dataRangeEnd = get(worksheet, 'cells', size(data, 1)+2, numCols+1);

r = get(worksheet, 'range', nameRangeStart, nameRangeEnd);
r.value = names(:)';
release(r); release(nameRangeStart); release(nameRangeEnd);

r = get(worksheet, 'range', unitRangeStart, unitRangeEnd);
r.value = charUnits;
release(r); release(unitRangeStart); release(unitRangeEnd);

r = get(worksheet, 'range', dataRangeStart, dataRangeEnd); 
r.value = data;
% BUG in export that doesn't write NaN and Inf correctly so replace with
% empty cells
r.value(~isfinite(data)) = {''};

release(r); release(dataRangeStart); release(dataRangeEnd);

release(worksheet);

% --------------------------------------------------------------------
%
% --------------------------------------------------------------------
function i_closeExcel(excelStruct)
activeBook = excelStruct.dataBook;
try
	server = get(activeBook, 'application');
   server.UserControl = false;
   activeBook.Close(false);
	release(activeBook);
	% If no workbooks are left open then close Excel
	% Make the application visible
	workbooks = get(server, 'workbooks');
	if get(workbooks, 'count') == 0
		invoke(server,'quit');
	end
	release(workbooks);
   release(server);
	%delete(server);
end
