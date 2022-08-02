function connect(obj)
%CONNECT Connect opcda object to server.
%   CONNECT(Obj) connects the opcda object Obj to the OPC server specified
%   by the Host and ServerID properties. When Obj is connected, the Status
%   property is set to 'connected'. When Obj is disconnected, the Status
%   property is set to 'disconnected'. You can disconnect Obj from the
%   server with the DISCONNECT function.
%
%   If Obj is an array of objects and one of the objects cannot be
%   connected, an attempt will be made to connect the remaining objects in
%   the array, and a warning message will be generated. If none of the
%   objects can be connected, an error message will be generated.
%
%   It is possible to create groups and items before connecting to the
%   server. However, servers impose restrictions on client group and item
%   names. Therefore, if you create a group hierarchy and then connect to
%   the server, groups or items that cannot be supported by the server are
%   automatically deleted, and a warning message is issued.
%
%   See also OPCDA/DISCONNECT.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.7 $  $Date: 2004/02/01 22:06:14 $

% Only connect to valid objects
I = isvalid(obj);
if ~any(I)
    rethrow(mkerrstruct('opc:connect:objinvalid'));
elseif ~all(I)
    warning('opc:connect:objinvalid','One or more objects are invalid. Connecting only to the valid objects.')
end

% Now we go into UDD mode:
uddHandle = getudd(obj);
uddValid = uddHandle(I);
% verify that the "status" really reflects the connected state
for uddThis=uddValid(:)'
    if strcmpi('connected',uddThis.Status)
        try
            udopcserverinfo(uddThis); 
        catch
            % opcserverinfo failed, which indicates a disconnected object.
            uddThis.uddisconnect;
        end
    end
end

% Make a failed container
failed = uddValid(1);
failed(1) = [];
errStruct = {};
for uddThis=uddValid(:)'
    % Don't reconnect
    if strcmpi('disconnected', uddThis.Status)
        try
            %sue: if the connect fails at this point, is it obvious that it is
            %due to the invalidity of the item?? If so, then the MexFunction
            %should return an error message which we propogate to the Matlab
            %command window. Code should be added to the Mexfile to delete
            %the respective 'invalid' item object
            uddThis.udconnect;
        catch
            uddThis.uddisconnect; %update the "status" property
            failed(end+1) = uddThis;
            errStruct{end+1} = mkerrstruct(lasterror);
        end
        % We will start with the groups, which are a property of the UDD
        % object
        if ~isempty(uddThis.Group),
            [newGroup, rFlag] = cleanup(uddThis.Group);
            if rFlag,
                warning('opc:connect:itemsremoved', ...
                    'One or more items do not exist on the server and have been deleted');
            end
            uddThis.udsetchild(newGroup);
        end
    end
end

% report any failures
if ~isempty(failed),
    if length(uddValid)==1,
        rethrow(mkerrstruct(errStruct{1}));
    else
        msgDetail = '';
        for k=1:length(failed)
            msgDetail = sprintf('%s\t%s returned ''%s''\n', msgDetail, failed(k).Name, errStruct{k}.message);
        end
        if length(failed)==length(uddValid),
            rethrow(mkerrstruct('opc:connect:failed', ...
                sprintf('Could not connect to servers:\n%s', msgDetail)));
        else
            warning('opc:connect:failed', 'One or more objects failed to connect:\n%s', msgDetail);
        end
    end
end
