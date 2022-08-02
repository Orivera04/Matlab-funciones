function out = propinfo(obj, prop)
%PROPINFO Return property information for OPC Toolbox objects.
%   Out = PROPINFO(Obj) returns a structure array, Out, with field names
%   given by the property names for Obj. Each property name in Out
%   contains a structure with the fields:
%   'Type' - the property data type: 
%       {'callback', 'double', 'string', 'any'}
%   'Constraint' - constraints on property values: 
%       {'bounded', 'enum', 'none', 'callback'}
%   'ConstraintValue' - cell array list or range of valid values.
%   'DefaultValue' - the default value for the property.
%   'ReadOnly' - the condition under which a property is read-only:
%       'always'  - property cannot be configured.
%       'never'  - property can always be configured.
%       'whileConnected' - property cannot be configured while Obj or the
%           client containing Obj, is connected to the server.
%       'whileLogging' - property cannot be configured while the object is 
%           logging.
%
%   Out = PROPINFO(Obj,'PropName') returns a structure array, Out, for the
%   property specified by PropName. If PropName is a cell array of
%   strings, a cell array of structures is returned for each property.
%
%   See also OPCHELP.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.3 $  $Date: 2004/02/01 22:07:03 $

% Error checking.
if ~isa(obj,'opcroot')
    rethrow(mkerrstruct('opc:propinfo:syntaxerror'));
elseif (length(obj) > 1)
    %TODO: Check if we can support propinfo on multiple objects!
    rethrow(mkerrstruct('opc:propinfo:vecnotsupported'));
elseif ~isvalid(obj),
    rethrow(mkerrstruct('opc:propinfo:objinvalid'));
end

% Extract the UDD object and get the property information.
uddobj = getudd(obj);
try
    switch nargin,
        case 1,
            out = propinfo(uddobj);
        case 2,
            out = propinfo(uddobj, prop);
    end
catch
    rethrow(mkerrstruct(lasterror));
end
