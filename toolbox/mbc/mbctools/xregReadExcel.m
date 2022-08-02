function [OK, msg, out] = xregReadExcel(filename, out)
% XREGREADEXCEL Reads in an Excel file

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.9.4.3 $  $Date: 2004/02/09 08:21:04 $




OK = 0;
msg = '';

% Start the Excel interface
excel = xregExcel('start');
server = get(excel.dataBook, 'application');
server.UserControl = false;   % User doesn't get to control this Excel
% Open the file filename
workbook = invoke(server.workbooks,'open',filename);
release(server);
% Get the worksheets array
worksheets = workbook.sheets;
% Iterate through worksheets getting names
List = [];
for i = 1:double(worksheets.count)
   worksheet = worksheets.Item(i);
   List = strvcat(List, get(worksheet,'name'));
   release(worksheet);
end

if size(List, 1) == 1
   OK = 1;
   index = 1;
else
	% Which sheet do we want
	[index, OK] = mv_listdlg('ListString',List,...
		'PromptString','Select Sheet',...
		'Name','Select Sheet',...
		'InitialValue',1,...
		'selectionmode','single',...
		'ListSize',[200 240],...
		'fus',5,...
		'ffs',8,...
		'uh',25);
end

if OK
    worksheet = worksheets.Item(index);
    try
        [varNames, varUnits, data] = xregExcel('read', excel, worksheet);
        out.varNames = varNames;
        out.varUnits = varUnits;
        out.data     = data;
        OK = 1;
    catch
        OK = 0;
        msg = lasterr;
    end
    release(worksheet);
end
%Close up nicely
release(worksheets);
% Sometimes Excel prompts you to save your changes
% we don't want that.
SaveChanges = false;
invoke(workbook, 'close', SaveChanges);
xregExcel('close', excel);
