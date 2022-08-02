function flushdata(obj)
%FLUSHDATA Remove all logged data associated with the dagroup object.
%   FLUSHDATA(GObj) removes all records associated with dagroup object
%   GObj from the OPC Toolbox engine, and sets RecordsAvailable to 0 for
%   that object.
%
%   GObj can be a scalar dagroup object, a vector of dagroup objects, or a
%   cell array containing dagroup objects.
%
%   See also DAGROUP/GETDATA, DAGROUP/PEEKDATA, DAGROUP/START, DAGROUP/STOP.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.5 $  $Date: 2004/03/24 20:42:54 $

I = isvalid(obj);
if ~any(I)
    rethrow(mkerrstruct('opc:flushdata:objinvalid'));
elseif ~all(I)
    warning('opc:flushdata:objinvalid', ...
        'One or more objects are invalid. Flushing data for valid objects only.')
end

uddHandle = getudd(obj);
uddValid = uddHandle(I);
failedMsg={};
for uddThis=uddValid(:)'
    try
        uddThis.udflushdata; 
    catch
        failedMsg{end+1} = sprintf('%s: %s', uddThis.Name, lasterr);
    end
end
if ~isempty(failedMsg),
    if length(failedMsg==length(uddValid)),
        rethrow(mkerrstruct('opc:flushdata:failed', sprintf('FLUSHDATA failed:\n%s', ...
            sprintf('\t%s\n', failedMsg{:}))));
    else
        warning('opc:flushdata:failed', 'FLUSHDATA failed for the following groups:\n%s', ...
            sprintf('\t%s\n', failedMsg{:}));
    end
end
