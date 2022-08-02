function setftsguidata(MAT_data, data_names, data_info)
%SETFTSGUIDATA Stores FTS data in Main FTS GUI Figure's UserData.
%

%   Author: P. N. Secakusuma, 01-10-2000
%   Copyright 1995-2003 The MathWorks, Inc.
%   $Revision: 1.3.2.2 $   $Date: 2004/04/06 01:09:46 $

if ~iscell(MAT_data),
    error('Please make it a cell array of data...');
end
if ~iscell(data_names),
    error('Please make it a cell array of name(s)...');
end
if ~iscell(data_info),
    error('Please make it a cell array of type(s)...');
end

mainFTSGUIWindow = findall(0, 'Type', 'figure', ...
    'Tag', 'FTSGUIMainWindow');
infostorage = getappdata(mainFTSGUIWindow, 'FTS_Data');

data_desc = {};
for didx = 1:length(MAT_data),
    data_desc{didx, 1} = MAT_data{didx}.desc;
end

infostorage.itemcount = infostorage.itemcount + length(data_names);
infostorage.itemnames = [infostorage.itemnames(:); data_names];
infostorage.itemdesc  = [infostorage.itemdesc(:); data_desc];
infostorage.items     = [infostorage.items(:); MAT_data];
infostorage.itemtypes = [infostorage.itemtypes(:); data_info];

setappdata(mainFTSGUIWindow, 'FTS_Data', infostorage);

return
		