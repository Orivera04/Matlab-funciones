function enumDispStr = createpropenumdisp(propertyName, enums, default)
%CREATEPROPENUMDISP Create a display string for property enumerations
%   CREATEPROPENUMDISP(PropertyName,Enums,Default) creates a display
%   of  all the enumerated values, Enums, for PropertyName in the 
%   following format:
%                       [ enum1 | enum2 | {enum3} ]
%   The default enumeratione, Default is indicated by {} braces.
%
%   If PropertyName does not have a fixed set of property values, a 
%   message indicating this is returned instead.
%
%   PropertyName is assumed to be the fully qualified property name.
%   Therefore, the  property name is case sensitive and name completion is
%   not performed.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.2 $  $Date: 2004/02/01 22:07:00 $

Nenums = length(enums);
if Nenums==0,
    % No enums available. Make sure we're not dealing with 
    % a callback property:
    if length(propertyName)>3 && strcmp(propertyName(end-2:end),'Fcn'),
        enumDispStr = 'string -or- function handle -or- cell array';
    else
        enumDispStr = ['The ''', propertyName, ...
                ''' property does not have a fixed set of property values.'];
    end
else
    % Create body: "[ append | index | overwrite |"
    % Then replace | with end bracket: "[ append | index | overwrite ]"
    % The add {} brackets around default value.
    enumDispStr = ['[' sprintf(' %s |', enums{:}) ];
    enumDispStr(end) = ']';    
    enumDispStr = strrep(enumDispStr, [' ' default ' '], [' {' default '} ']);
end