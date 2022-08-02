function varargout = xregImportExcelDataWiz(action, varargin)
% XREGLOADDATAWIZ

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.2 $  $Date: 2004/02/09 08:21:01 $



switch lower(action)
case 'cardone'
	[varargout{1:nargout}] = i_createCardOne(varargin{:});
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
	nextText = xregGui.uicontrol('parent', fh,...
		'style', 'text',...
		'horizontal','center',...
		'string', 'Enter your data in Excel and click Next to import ...');
	 
    layout = xreggridbaglayout(fh,...
		'dimension', [3 1],...
		'elements', {[] nextText []},...
		'rowsizes', [-1 60 -1],...
		'colsizes', [-1],...
		'border', [30 0 30 0],...
		'rowratios',[.5 0 .5]);
    
	layoutUD.mergeSweepset = [];
	
    layoutUD.figure     = fh;
	layoutUD.nextFcn    = @i_cardOneNext;
end

% Start the excel server
layoutUD.excel = xregExcel('start');
% Prepare the data page
xregExcel('prepare', layoutUD.excel)

if nargin > 2
	layoutUD.mergeSweepset = localData.mergeSweepset;
end
feval(iFace.setNextButton,   'on');
feval(iFace.setFinishButton, 'off');
set(layout, 'userdata', layoutUD);

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function [nextCardID, localData] = i_cardOneNext(layoutUD, iFace)
% Only set when sure that this has completed sucessfully
nextCardID = [];
localData  = [];
% Check that Excel is still open
chan = ddeinit('excel','MBC Data');
% Has excel been closed?
if chan == 0
	waitfor(warndlg('Excel has closed. No data available for import', 'Excel Import Error', 'modal'));
    xregExcel('close', layoutUD.excel);
	return
end
% Indicate that this might take some time
set(layoutUD.figure, 'pointer', 'watch')
% Read from the sheet
[names, units, data] = xregExcel('read', layoutUD.excel);
% Reset the pointer
set(layoutUD.figure, 'pointer', 'arrow')
% Ensure that excel is closed
xregExcel('close', layoutUD.excel);


localData.filename = 'Excel Import';
localData.newSweepset = sweepset('Variable', 1:length(names), '', names, '', units, '', data);
localData.mergeSweepset = layoutUD.mergeSweepset;
nextCardID = @i_createCardTwo;


%------------------------------------------------------------------------
% CARD TWO FUNCTIONS BELOW
%------------------------------------------------------------------------

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function layout = i_createCardTwo(varargin)
% Jump to the 3 final cards of the normal data loading wizard
layout = xregLoadDataWiz('cardtwo', varargin{:});
