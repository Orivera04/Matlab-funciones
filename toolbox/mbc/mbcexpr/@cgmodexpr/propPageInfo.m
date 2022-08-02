function hInfo = propPageInfo(obj, hPropDialog)
%PROPPAGEINFO Create the Information property tab
%
%  INFO = PROPPAGEINFO(OBJ, HPROPDIALOG) creates the info object that
%  represents the model's Information tab in a property dialog.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/04/12 23:34:39 $ 

hInfo = xregGui.propertyPageInfo('Information');
hInfo.HelpHandler = 'cghelptool';
hInfo.HelpCode = 'CGMODELPROPPAGEINFO';

mdl = get(obj, 'model');
INFO = getinfo(mdl);

if ~isempty(INFO)
    % Basic properties
    props = { ...
        'User', INFO.User; ...
        'Date', INFO.Date; ...
        'MBC Version', ''};   
    if isfield(INFO, 'mvver')
        props{3,2} = INFO.mvver;
    else
        props{3,2} = INFO.Version;
    end
    
    % User-added properties
    if isfield(INFO, 'new')
        % Skip the first cell that might contain engine data
        NumExtra = length(INFO.new) - 1;
        propidx = size(props, 1) + 1;
        props = [props; cell(NumExtra, 2)];
        for n = 2:(1+NumExtra)
            props{propidx, 1} = INFO.new{n}.Title;
            props{propidx, 2} = INFO.new{n}.Description;
            propidx = propidx + 1;
        end
    end
else
    props = cell(0,2);
end

hInfoPane = xregGui.infoPane('Parent', hPropDialog.Figure, ...
    'Visible', 'off', ...
    'TitleText', {'Field', 'Value'});
hInfoPane.ListText = props;

hInfo.TabComponent = xregpanellayout(hPropDialog.Figure, ...
    'visible', 'off', ...
    'innerborder', [0 0 0 0], ...
    'border', [10 10 10 10], ...
    'center', hInfoPane);
