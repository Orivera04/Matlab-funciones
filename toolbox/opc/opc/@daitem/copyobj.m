function newObj = copyobj(obj, parent)
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
%    $Revision: 1.1.6.1 $  $Date: 2004/03/24 20:43:01 $

%%% Error checking
% Cannot work on totally invalid objects.
v = isvalid(obj);
if ~any(v),
    rethrow(mkerrstruct('opc:copyobj:objinvalid'));
elseif ~all(v)
    warning('opc:copyobj:objinvalid', 'Cannot copy invalid objects. Only valid objects will be copied.');
end
% If a parent is defined, is it valid?
if nargin>1,
    if length(parent)>1,
        rethrow(mkerrstruct('opc:copyobj:parentvector'));
    end
    if ~strcmp(class(parent), 'dagroup'),
        rethrow(mkerrstruct('opc:copyobj:parenttype'));
    end
end

%%% Construct the copies
uddObj = getudd(obj);
uddValid = uddObj(v);   % Need these for indexing
% The parent, an OPCDA object
if nargin<2
    % We need to make a parent object
    parent = copyobj(uddValid(1).Parent);
    % That operation copied everything.
    siblings = get(parent, 'Item');
    newObj = obj;
    for k=1:length(newObj)
        if v(k),
            % We need to replace this one with the copy
            newFound = opcfind('Type', 'daitem', ...
                'Parent', parent, ...
                'ItemID', uddObj(k).ItemID);
            newObj = subsasgn(newObj, struct('type', '()', 'subs', {{k}}), newFound{1});
        end
    end
else
    %%% The real copy operation!
    newObj = [];
    errMsg = {};
    for k=1:length(uddValid)
        uddThis = uddValid(k);
        thisID = uddThis.ItemID;
        try
            thisObj = additem(parent, thisID);
            thisObj = setpropsfromudd(thisObj, uddThis);
            if isempty(newObj)
                newObj = thisObj;
            else
                newObj = [newObj thisObj];
            end
        catch
            errMsg{end+1} = sprintf('Group ''%s'' returned: ''%s''', thisID, lasterr);
        end
    end
    % Display errors/warnings
    objInfo = sprintf('\t%s\n', errMsg{:});
    if isempty(newObj),
        rethrow(mkerrstruct('opc:copyobj:failed', sprintf('Copy operation failed:\n%s', objInfo)));
    elseif ~isempty(errMsg)
        warning('opc:copyobj:failed', ...
            sprintf('Copy operation failed for the following groups:\n%s', objInfo));
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function obj = setpropsfromudd(obj, uddObj)
%SETPROPRFROMUDD Sets all Non-RO properties from uddObj to Obj.
pv = get(uddObj);
props = fieldnames(pv);
for k=1:length(props)
    thisProp = props{k};
    pi = propinfo(obj, thisProp);
    if ~strcmpi(pi.ReadOnly, 'always') && ~strcmp(thisProp, 'ItemID')
        set(obj, props{k}, pv.(props{k}));
    end
end