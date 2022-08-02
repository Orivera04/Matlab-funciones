function [ftsData, ftsName] = execftsdatafcn(fcn_name, varargin)
%EXECFTSDATAFCN Executes a FINTS method on the active time series data.
%

%   Author: P. N. Secakusuma, 01-10-2000
%   Copyright 1995-2003 The MathWorks, Inc.
%   $Revision: 1.4.2.2 $   $Date: 2004/04/06 01:09:42 $

mainFTSGUIWindow = findall(0, 'Type', 'figure', 'Tag', 'FTSGUIMainWindow');

infostorage = getappdata(mainFTSGUIWindow, 'FTS_Data');

% For basic statistics, do not append infostorage info.
menuOption = '';
if nargin == 2
    menuOption = varargin{1};
end

if isempty(infostorage.activefts)
    errordlg('No data loaded or no active FTS is selected.', 'Active FTS');
    
else
    [MAT_data, data_names, data_info] = getftsguidata(infostorage.activefts);
    if ~strcmpi(menuOption, 'stats')
        resultFTS = feval(fcn_name, MAT_data, varargin{:});
    else
        % Special case for basic statistic menu option
        resultFTS = feval(fcn_name, MAT_data);
    end

    % Return the results
    ftsData = resultFTS;
    ftsName = [fcn_name, '_', infostorage.activefts];
    
    if ~strcmpi(menuOption, 'stats')
        % Add result to FTSGUIData. Make sure all fields are stored as column
        % vectors.
        infostorage.itemcount = infostorage.itemcount + 1;
        infostorage.itemnames = [infostorage.itemnames; cellstr(ftsName)];
        if isa(ftsData, 'FINTS')
            % Get description from transformed object.
            infostorage.itemdesc = [infostorage.itemdesc; cellstr(ftsData.desc)];

        else
            % Get description from original object because no transformation took
            % place.
            infostorage.itemdesc = [infostorage.itemdesc; cellstr(MAT_data.desc)];
        end
        infostorage.items = [infostorage.items; {ftsData}];
        infostorage.itemtypes = [infostorage.itemtypes; {'fints'}];

        setappdata(mainFTSGUIWindow, 'FTS_Data', infostorage);
    end
end

return
