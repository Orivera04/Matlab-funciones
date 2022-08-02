function newObj = copyobj(obj)
%COPYOBJ Make a copy of an OPC Toolbox object.
%   NewObj = COPYOBJ(Obj) makes a copy of all the objects in Obj, and
%   returns them in NewObj. Obj can be a scalar OPC Toolbox object, or a
%   vector of OPC Toolbox objects.
%
%   A copied OPC Toolbox object contains new versions of all children,
%   their children, and any parents that are required to construct that
%   object.
%
%   NewObj = COPYOBJ(Obj,ParentObj) makes a copy of the objects in Obj in
%   the parent object ParentObj. ParentObj must be a valid scalar parent
%   object for Obj. If any objects in Obj cannot be created in ParentObj, a
%   warning will be generated.
%
%   A copied object is different from its parent object in the following
%   ways:
%   - The values of read-only properties will not be copied to the new
%   object. For example, if an object is saved with a Status property value
%   of 'connected', the object will be recreated with a Status property
%   value of 'disconnected' (the default value). You can use PROPINFO to
%   determine if a property is read-only.
%   - A copied DAGROUP object that had records in memory from a logging
%   session is copied without those records.
%
%   See Also OPCROOT/OBJ2MFILE, OPCROOT/PROPINFO

%    Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd 
%    $Revision: 1.1.6.1 $  $Date: 2004/03/24 20:43:08 $

%%% Error checking
% Cannot work on totally invalid objects.
v = isvalid(obj);
if ~any(v),
    rethrow(mkerrstruct('opc:copyobj:objinvalid'));
elseif ~all(v)
    warning('opc:copyobj:objinvalid', 'Cannot copy invalid objects. Only valid objects will be copied.');
end

%%% Construct the copies
uddObj = getudd(obj);
uddValid = uddObj(v);   % Need these for indexing
newObj = [];
errMsg = {};
for k=1:length(uddValid)
    uddThis = uddValid(k);
    thisName = uddThis.Name;
    
    try
        thisObj = opcda(uddThis.Host, uddThis.ServerID);
        thisObj = setpropsfromudd(thisObj, uddThis);
        % Finally, copy the children into this object.
        if ~isempty(uddThis.Group),
            copyobj(uddThis.Group, thisObj);
        end
        if isempty(newObj)
            newObj = thisObj;
        else
            newObj = [newObj thisObj];
        end
    catch
        errMsg{end+1} = sprintf('Client ''%s'' returned: ''%s''', thisName, lasterr);
    end
end
% Display errors/warnings
objInfo = sprintf('\t%s\n', errMsg{:});
if isempty(newObj),
    rethrow(mkerrstruct('opc:copyobj:failed', sprintf('Copy operation failed:\n%s', objInfo)));
elseif ~isempty(errMsg),
    warning('opc:copyobj:failed', ...
        sprintf('Copy operation failed for the following groups:\n%s', objInfo));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function obj = setpropsfromudd(obj, uddObj)
%SETPROPRFROMUDD Sets all Non-RO properties from uddObj to Obj.
pv = get(uddObj);
props = fieldnames(pv);
for k=1:length(props)
    thisProp = props{k};
    pi = propinfo(obj, thisProp);
    if ~strcmpi(pi.ReadOnly, 'always') && ~any(strncmp(thisProp, {'Host', 'ServerID'}, length(thisProp)))
        set(obj, props{k}, pv.(props{k}));
    end
end