function hiliteSystem(index)
%function hiliteSystem(encodedObjName)
% hilite HTML encoded object name

%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $ $Date: 2002/11/27 17:40:15 $

mlock
persistent last_system
%originalObjName = HTMLencode(encodedObjName, 'decode');
%system = originalObjName{:};
FOUND_OBJECTS = HTMLattic('AtticData', 'FOUND_OBJECTS');
system = FOUND_OBJECTS(str2num(index)).handle;
if isa(system, 'Stateflow.Data')
    system.dialog;      % open dialog for Stateflow.Data object
    return
else
    try
        systemType = get_param(system, 'Type');
    catch
        errordlg('Unsupported object type.');
        return
    end
end
if isprop(system, 'MaskType')
    maskType = get_param(system, 'MaskType');
end

% un-hilite last time hilited system
if ~isempty(last_system);
    try
        hilite_system(last_system, 'none');
    catch
    end
end
  try
    %notRoot = findstr('/', system);
    notRoot = get_param(system, 'parent');
    if ~isempty(notRoot)
        tryagain = 0;
        try 
            hilite_system(system, 'find');
            if strcmpi(systemType, 'block')
                if isprop(system, 'MaskType')
                    if strcmpi(maskType, 'Stateflow') % we'll open property dialog directly for stateflow charts
                        subsystemObj=get_param(system, 'Object');
                        chartObj = subsystemObj.getHierarchicalChildren;
                        chartObj.dialog;
                    else
                        open_system(system); % only open dialog for blocks
                    end
                else
                    open_system(system); % only open dialog for blocks
                end
            end            
        catch
            tryagain = 1;
        end
        if tryagain
            % if the user accidentally closes the system, we will attempt to
            % open it again
            %        try
            %open_system(system(1:(notRoot(1)-1)));
            hilite_system(system, 'find');
            if strcmpi(systemType, 'block')
                if isprop(system, 'MaskType')
                    if strcmpi(maskType, 'Stateflow') % we'll open property dialog directly for stateflow charts
                        subsystemObj=get_param(system, 'Object');
                        chartObj = subsystemObj.getHierarchicalChildren;
                        chartObj.dialog;
                    else
                        open_system(system); % only open dialog for blocks
                    end
                else
                    open_system(system); % only open dialog for blocks
                end
            end            
            %        catch
            %        end
        end
    else
        % there is no '/' in the system, i.e. it is a root of 
        % a model; current hilite_system won't work on a model
        % so we have to use a trick to get around it
        open_system(system);
    end
    last_system = system;
catch
end