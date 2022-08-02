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
% $Revision: 1.1.6.6 $  $Date: 2004/03/24 20:43:09 $

if isempty(obj)
    return
end

% Only delete valid objects
I = isvalid(obj);
uddHandle = getudd(obj);
uddValid = uddHandle(I);
failedMsg = {};
for uddThis=uddValid(:)'
    try
        uddThis.uddisconnect;
        delete(uddThis);
        %uddThis.disconnect;
    catch
        failedMsg{end+1} = sprintf('%s: %s', uddThis.Name, lasterr);
    end
end
if ~isempty(failedMsg),
    if length(failedMsg)==length(uddValid),
        rethrow(mkerrstruct('opc:delete:failed', sprintf('DELETE failed:\n%s', ...
            sprintf('\t%s\n', failedMsg{:}))));
    else
        warning('opc:delete:failed', 'DELETE failed for the following objects:\n%s', ...
            sprintf('\t%s\n', failedMsg{:}));
    end
end
