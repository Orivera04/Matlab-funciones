function out = ne(arg1, arg2)
%NE Overload of ~= relational operator for OPC Toolbox objects
%
%   See also OPCROOT/EQ

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.3 $  $Date: 2004/02/01 22:06:42 $

try
    out = ~eq(arg1,arg2);
    if isa(arg1, 'opcroot'),
        out(~isvalid(arg1)) = false;
    end
    if isa(arg2, 'opcroot'),
        out(~isvalid(arg2)) = false;
    end
    
catch
    % Replace the error ID, so assume the error is formatted okay.
    errStruct = lasterror;
    errStruct.identifier = strrep(errStruct.identifier, 'eq:', 'ne:');
    rethrow(errStruct);
end