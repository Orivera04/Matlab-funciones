function delete(obj)
%DELETE Remove OPC Toolbox objects from memory.
%   DELETE(Obj) removes the OPC Toolbox object Obj from memory. Obj can be
%   an array of objects. A deleted object becomes invalid and references
%   to that object should be removed from the workspace with the CLEAR
%   command. If you delete an object that contains children (groups or
%   items), then the children are also deleted and references to these
%   children should be removed.
%
%   If multiple references to an OPC Toolbox object exist in the
%   workspace, then deleting one object invalidates the remaining
%   references.
%
%   If Obj is an OPCDA object connected to the server when DELETE is
%   called, the object will be disconnected and then deleted.
%
%   Examples
%       da = opcda('localhost','Matrikon.OPC.Simulation');
%       connect(da);
%       grp = addgroup(da,'DeleteEx');
%       itm = additem(grp,'Random.Real4');
%       r = read(grp)
%       delete(grp);    % deletes itm as well
%       clear grp itm
%
%   See also OPCDA/DISCONNECT, OPCROOT/ISVALID.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.5 $  $Date: 2004/02/01 22:06:07 $

if isempty(obj)
    return
end

% Only delete valid objects
I = isvalid(obj);
uddHandle = getudd(obj);
uddValid = uddHandle(I);
if ~isempty(uddValid),
    % Delete the item(s) from the parent property. This is done by replacing
    % the Item property with the items which are not being removed from
    % the parent.
    parentObj = uddValid(1).Parent;
    origParentItem = get(parentObj,'Item');
    origItemUDD = getudd(origParentItem);
    [newItemUDD, itmInd] = setdiff(origItemUDD, uddValid);
    % Now how do we use the itmInd values? SUBSREF call!!!
    if isempty(newItemUDD),
        newItem = [];
    else
        newItem = subsref(origParentItem, struct('type','()', 'subs',itmInd));
    end
    % [sue] - start
    %opcmex('itemadd',getudd(parentObj),newItem);
    udsetchild(getudd(parentObj), newItem);
    % [sue] - end    
    
    delete(uddValid);
end
