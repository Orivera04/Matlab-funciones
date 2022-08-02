function updateftsguistatus(statusflag, statusText)
%UPDATEFTSGUISTATUS Updates the status list in the main FTS GUI window.
%
%   updateftsguistatus(STATUSFLAG, STATUSTEXT) updates/adds the status
%   STATUSTEXT to the current status list if the STATUSFLAG is 1 or 
%   'add'.  If STATUSFLAG is 0 or 'clear', STATUSTEXT becomes irrelevant
%   and the status list is cleared.
%
%   NOTE: This is a private function that is used by the FTSGUI suite
%         of functions.  It is not for general consumption.
%

%   Author: P. N. Secakusuma, 02-11-2000
%   Copyright 1995-2003 The MathWorks, Inc.
%   $Revision: 1.3.2.2 $   $Date: 2004/04/06 01:09:47 $

hStatusList = findall(0, 'Type',  'uicontrol' , ...
    'Style', 'listbox'   , ...
    'Tag',   'ftsguiStatusList');

switch statusflag,
    case {0, 'clear'},
        newStatusList = '';

    case {1, 'add'},
        oldStatusList = get(hStatusList, 'String');
        if strcmp(class(oldStatusList), 'char'),
            oldStatusList = cellstr(oldStatusList);
        end
        if cellfun('isempty', oldStatusList),
            newStatusList = {statusText};
        else,
            newStatusList = [oldStatusList; {statusText}];
        end

    otherwise,
        error('Invalid StatusFlag...');

end

% Set new StatusList string.
set(hStatusList, 'String', newStatusList, ...
    'ListboxTop', max(length(newStatusList), 1));

return
