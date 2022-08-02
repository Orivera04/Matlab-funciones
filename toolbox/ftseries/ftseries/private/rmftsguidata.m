function rmftsguidata(data_names)
%RMFTSGUIDATA Removes FTS data from Main FTS GUI Figure's FTS_Data.
%

%   Author: P. N. Secakusuma, 01-10-2000
%   Copyright 1995-2003 The MathWorks, Inc.
%   $Revision: 1.2.2.2 $   $Date: 2004/04/06 01:09:45 $

mainFTSGUIWindow = findall(0, 'Type', 'figure', ...
    'Tag', 'FTSGUIMainWindow');
infostorage = getappdata(mainFTSGUIWindow, 'FTS_Data');

dname_idx = ~strcmp(data_names, infostorage.itemnames);

infostorage.itemcount = infostorage.itemcount - 1;
infostorage.itemnames = infostorage.itemnames(dname_idx);
infostorage.itemdesc  = infostorage.itemdesc(dname_idx);
infostorage.items     = infostorage.items(dname_idx);
infostorage.itemtypes = infostorage.itemtypes(dname_idx);
infostorage.activefts = [];
infostorage.activefig = [];

setappdata(mainFTSGUIWindow, 'FTS_Data', infostorage);

return		
