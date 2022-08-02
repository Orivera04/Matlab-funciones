function [MAT_data, data_names, data_info] = getftsguidata(fts_name)
%GETFTSGUIDATA Fetches FTS data from Main FTS GUI Figure's UserData.
%

%   Author: P. N. Secakusuma, 01-10-2000
%   Copyright 1995-2003 The MathWorks, Inc.
%   $Revision: 1.4.2.2 $   $Date: 2004/04/06 01:09:43 $

mainFTSGUIWindow = findall(0, 'Type', 'figure', ...
    'Tag', 'FTSGUIMainWindow');

infostorage = getappdata(mainFTSGUIWindow, 'FTS_Data');

switch nargin
    case 0
        MAT_data   = infostorage.items;
        data_names = infostorage.itemnames;
        data_info  = infostorage.itemtypes;
    case 1
        fts_idx    = find(strcmp(fts_name, infostorage.itemnames));
        MAT_data   = infostorage.items{fts_idx};
        data_names = infostorage.itemnames{fts_idx};
        data_info  = infostorage.itemtypes{fts_idx};
    otherwise
        error('Invalid number of input arguments for GETFTSGUIDATA...');
end

% [EOF]
