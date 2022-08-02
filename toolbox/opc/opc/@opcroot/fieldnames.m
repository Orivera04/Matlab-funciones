function out = fieldnames(obj, flag)
%FIELDNAMES Get OPC Toolbox object property names.
%   Names = FIELDNAMES(Obj) returns a cell array of strings containing 
%   the names of the properties associated with OPC Toolbox object, Obj.
%   OBJ can be an array of OPC Toolbox objects.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.3 $  $Date: 2004/02/01 22:06:36 $

if ~isa(obj, 'opcroot') || ~all(isvalid(obj))
    rethrow(mkerrstruct('opc:fieldnames:objinvalid'));
end

try
    out = fieldnames(get(obj));
catch
    rethrow(mkerrstruct(lasterror));
end