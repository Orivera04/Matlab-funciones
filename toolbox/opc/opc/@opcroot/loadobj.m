function obj = loadobj(B)
%LOADOBJ Load filter for OPC Toolbox objects.
%
%    OBJ = LOADOBJ(B) is called by LOAD when an OPC Toolbox object is 
%    loaded from a .MAT file. The return value, OBJ, is subsequently 
%    used by LOAD to populate the workspace.  
%
%    LOADOBJ will be separately invoked for each object in the .MAT file.
%
%    See also OPC/PRIVATE/LOAD.
%

%    Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd 
%    $Revision: 1.1.6.1 $  $Date: 2004/03/24 20:43:28 $

% If we return early, return the original object.
obj = B;

% Convert this object to a low-level structure
s = struct(B);
% If udlist field is empty, we're not dealing with the parent object, so
% ignore it!
if isempty(s.udlist)
    return
end

%%% Reconstruct all the UDD objects in the udlist field
% Create all the OPCDA objects first
if ~isempty(s.udlist)
    for u = 1:length(s.udlist.opcda)
        thisUDL = s.udlist.opcda(u);
        % Do we need to construct this UDD object?
        sameObj = opcfind('udid', thisUDL.udid);
        if isempty(sameObj)
            pvPairs = thisUDL.props;
            udobj = opcda(pvPairs.Host, pvPairs.ServerID);
        else
            udobj = sameObj{1};
        end
        % Reset the object to the "default" state.
        disconnect(udobj);
        set(getudd(udobj), 'udid', thisUDL.udid);
        daObj(u)=udobj;
    end
    % All the dagroup objects can now be created.
    for u = 1:length(s.udlist.dagroup)
        thisUDL = s.udlist.dagroup(u);
        % Do we need to construct this UDD object?
        sameObj = opcfind('udid', thisUDL.udid);
        if isempty(sameObj)
            pvPairs = thisUDL.props;
            udid = getrefid(thisUDL.parent);
            % Now we need the parent, which we're guaranteed to have
            % created already
            parent = opcfind('udid', udid{1});
            udobj = addgroup(parent{1}, pvPairs.Name);
        else
            udobj = sameObj{1};
        end
        % Reset the object to the "default" state.
        stop(udobj);
        flushdata(udobj);
        udobj.uddobject.udid = thisUDL.udid;
        grpObj(u) = udobj;
    end
    % All the daitem objects can now be created.
    for u = 1:length(s.udlist.daitem)
        thisUDL = s.udlist.daitem(u);
        % Do we need to construct this UDD object?
        sameObj = opcfind('udid', thisUDL.udid);
        if isempty(sameObj)
            pvPairs = thisUDL.props;
            udid = getrefid(thisUDL.parent);
            % Now we need the parent, which we're guaranteed to have
            % created already
            parent = opcfind('udid', udid{1});
            udobj = additem(parent{1}, pvPairs.ItemID);
        else
            udobj = sameObj{1};
        end
        udobj.uddobject.udid = thisUDL.udid;
        itmObj(u) = udobj;
    end
    %%% Now populate their fields, replacing UDD objects as appropriate
    % If we do this now, we don't have to recurse through the objects!
    for u=1:length(s.udlist.opcda)
        % Populate the fields of the object
        setfields(daObj(u), s.udlist.opcda(u).props);
    end
    for u=1:length(s.udlist.dagroup)
        % Populate the fields of the object
        setfields(grpObj(u), s.udlist.dagroup(u).props);
    end
    for u=1:length(s.udlist.daitem)
        % Populate the fields of the object
        setfields(itmObj(u), s.udlist.daitem(u).props);
    end
end

%%% Remove the udlist, since we're done creating UDD objects.
s.udlist = [];
%%% Convert the struct (back) to an object.
obj = opcroot(s);
%%% Reconstruct the links to all the OPC Toolbox objects.
superObj = convertrefs(obj);
obj.uddobject = superObj.uddobject;
% Remove the references, since they are no longer needed.
obj.udrefid = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function setfields(udobj, props)
%SETFIELD Sets the fields of a UDD object to the values stored in props
%   In this case, props contains only writable values.
propNames = fieldnames(props);
for p = 1:length(propNames)
    thisVal = props.(propNames{p});
    if isa(thisVal, 'opcroot') || ...
            isa(thisVal, 'struct') || ...
            isa(thisVal, 'cell')
        thisVal = convertvalue(thisVal);
    end
    set(udobj, propNames{p}, thisVal);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function newObj = convertrefs(obj)
%CONVERTREFS Convert loaded objects to their real versions
% If there's stuff in the UDD field, it's converted!
newObj = [];
if ~isempty(getudd(obj)),
    newObj = obj;
else
    myRefID = getrefid(obj);
    % We're going to deal with the refid, so delete it from the object
    obj.udrefid = [];
    for k=1:length(myRefID)
        foundObj = opcfind('udid', myRefID{k});
        if isempty(foundObj)
            % Need to construct an invalid object!
            thisObj = obj;
            thisObj.uddobject = myRefID{k};
        else
            thisObj = foundObj{1};
        end
        % Now assign this to my new object vector
        if isempty(newObj)
            newObj = thisObj;
        else
            newObj(end+1) = thisObj;
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function udid = getrefid(obj)
%GETREFID returns the reference ID stored in an object
s = struct(obj);
if isfield(s,'opcroot'),
    s = struct(s.opcroot);
end
udid = s.udrefid;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function val = convertvalue(val)
%CONVERTVALUE Converts a value to it's UDD version.
if isa(val, 'opcroot') && isempty(getudd(val))
    val = convertrefs(val);
elseif isa(val, 'struct')
    fn = fieldnames(val);
    % Loop through the elements
    for s=1:length(val)
        % Loop through the fields
        for k=1:length(fn)
            sVal = val(s).(fn{k});
            if isa(sVal, 'opcroot') || ...
                    isa(sVal, 'cell') || ...
                    isa(sVal, 'struct')
                val(s).(fn{k}) = convertvalue(sVal);
            end
        end
    end
elseif isa(val, 'cell')
    % Loop through each element in the cell array
    for k=1:numel(val)
        cVal = val{k};
        if isa(cVal, 'opcroot') || ...
                isa(cVal, 'cell') || ...
                isa(cVal, 'struct')
            val{k} = convertvalue(cVal);
        end
    end
end